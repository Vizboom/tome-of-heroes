-- Fix: players stuck on "loading map…" in the Curse of Strahd campaign.
--
-- The "members read" policy checked campaign_members directly, so it was
-- subject to campaign_members' own row-level security: if a player can't read
-- their own membership row there (or its policy refers to itself), the check
-- fails and the map image comes back empty. This adds a small SECURITY
-- DEFINER function that answers "is the signed-in user a member of this
-- campaign?" without going through campaign_members' policies, and points the
-- policy at it. It only ever reveals the caller's own membership.
--
-- Run it once in the Supabase SQL editor (after strahd-map-pack-policy.sql
-- and strahd-map-pack-dm-upgrade.sql). To undo the function:
--   drop function if exists public.toh_is_campaign_member(text);
-- (then re-run strahd-map-pack-dm-upgrade.sql to restore the old check).

create or replace function public.toh_is_campaign_member(p_camp text)
  returns boolean
  language sql stable security definer
  set search_path = public
as $$
  select exists (
    select 1 from public.campaign_members
    where campaign_id = p_camp and user_id = auth.uid()
  )
$$;

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

  drop policy if exists "strahd maps: members read" on public.settings;
  execute format($p$
    create policy "strahd maps: members read" on public.settings
      as restrictive for select to public
      using (not starts_with(key, %L)
        or auth.uid() = %L::uuid
        or (not starts_with(key, %L) and public.toh_is_campaign_member(%L)))
  $p$, pre, owner, dm, camp);
end $$;
