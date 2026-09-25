-- Upgrade for anyone who already ran strahd-map-pack-policy.sql:
-- makes the Curse of Strahd DM maps readable by the owner only.
--
-- DM map images are stored under  camp_map_camp_m49562377d1_dm_<map id>.
-- This replaces the "members read" policy so campaign members can still read
-- every other map of the campaign, but only the owner (VIZBOOM) can read the
-- DM ones. Run it once in the Supabase SQL editor.

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
        or (not starts_with(key, %L) and exists (
          select 1 from public.campaign_members cm
          where cm.campaign_id = %L and cm.user_id = auth.uid())))
  $p$, pre, owner, dm, camp);
end $$;
