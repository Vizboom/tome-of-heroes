-- Curse of Strahd map pack: lock its map images to that campaign.
--
-- Uploaded map images live in public.settings under the key
--   camp_map_<campaign id>_<map id>          (see _storeMapImage in index.html)
-- For the Curse of Strahd campaign (camp_m49562377d1) these policies allow:
--   * read      — members of that campaign only (campaign_members);
--                 DM maps (keys with _dm_ after the campaign) the owner only
--   * add, change, delete — the pack's owner (VIZBOOM) only
-- They are RESTRICTIVE, so Postgres ANDs them with the table's existing
-- policies: nothing outside that campaign's map images changes.
--
-- The owner's user id is looked up from campaign_members when this runs, so
-- it isn't written into the repo. Run it once in the Supabase SQL editor.
--
-- To undo:
--   drop policy if exists "strahd maps: members read"   on public.settings;
--   drop policy if exists "strahd maps: owner inserts" on public.settings;
--   drop policy if exists "strahd maps: owner updates" on public.settings;
--   drop policy if exists "strahd maps: owner deletes" on public.settings;
--   drop function if exists public.toh_is_campaign_member(text);

-- Membership is checked through a SECURITY DEFINER function, so it doesn't
-- depend on campaign_members' own row-level security.
create or replace function public.toh_is_campaign_member(p_camp text)
  returns boolean
  language sql stable security definer
  set search_path = public
as $fn$
  select exists (
    select 1 from public.campaign_members
    where campaign_id = p_camp and user_id = auth.uid()
  )
$fn$;

do $$
declare
  camp  constant text := 'camp_m49562377d1';
  pre   constant text := 'camp_map_' || camp || '_';
  dm    constant text := pre || 'dm_';
  owner uuid;
begin
  select cm.user_id into owner
  from public.campaign_members cm
  where cm.campaign_id = camp and upper(cm.username) = 'VIZBOOM'
  limit 1;
  if owner is null then
    raise exception 'VIZBOOM is not a member of % — nothing changed', camp;
  end if;

  execute format($p$
    create policy "strahd maps: members read" on public.settings
      as restrictive for select to public
      using (not starts_with(key, %L)
        or auth.uid() = %L::uuid
        or (not starts_with(key, %L) and public.toh_is_campaign_member(%L)))
  $p$, pre, owner, dm, camp);

  execute format($p$
    create policy "strahd maps: owner inserts" on public.settings
      as restrictive for insert to public
      with check (not starts_with(key, %L) or auth.uid() = %L::uuid)
  $p$, pre, owner);

  execute format($p$
    create policy "strahd maps: owner updates" on public.settings
      as restrictive for update to public
      using (not starts_with(key, %L) or auth.uid() = %L::uuid)
      with check (not starts_with(key, %L) or auth.uid() = %L::uuid)
  $p$, pre, owner, pre, owner);

  execute format($p$
    create policy "strahd maps: owner deletes" on public.settings
      as restrictive for delete to public
      using (not starts_with(key, %L) or auth.uid() = %L::uuid)
  $p$, pre, owner);
end $$;
