-- Lock uploaded campaign map images to that campaign's members.
--
-- Map images are stored in public.settings under the key
--   camp_map_<campaign id>_<map id>
-- (see _storeMapImage in index.html). This adds a RESTRICTIVE policy, which
-- Postgres ANDs with the table's existing permissive policies: it narrows
-- access to camp_map_ rows only, and leaves every other settings row
-- (per-user settings, invite codes, …) exactly as the current policy allows.
--
-- Run it once in the Supabase SQL editor. To undo:
--   drop policy "camp map images: campaign members only" on public.settings;

-- First, see what is already there:
--   select policyname, permissive, roles, cmd, qual, with_check
--   from pg_policies where schemaname = 'public' and tablename = 'settings';

create policy "camp map images: campaign members only"
  on public.settings
  as restrictive
  for all
  to public
  using (
    not starts_with(key, 'camp_map_')
    or exists (
      select 1 from public.campaign_members cm
      where cm.user_id = auth.uid()
        and starts_with(settings.key, 'camp_map_' || cm.campaign_id || '_')
    )
  )
  with check (
    not starts_with(key, 'camp_map_')
    or exists (
      select 1 from public.campaign_members cm
      where cm.user_id = auth.uid()
        and starts_with(settings.key, 'camp_map_' || cm.campaign_id || '_')
    )
  );
