-- =============================================================================
-- 测试开关：让世界议会尽快、频繁地开会，并让神权理事会不受时代限制。只在测试时启用。
-- 参数来自 DLC/Expansion2/Data/Expansion2_GlobalParameters.xml：
--   WORLD_CONGRESS_INITIAL_ERA            官方 2（中世纪）：世界议会从哪个时代开始开会。改为 0。
--   WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS  官方 30：两次例会的最长间隔。改为 3。
-- 需实证：INITIAL_ERA = 0 时首次开会是否立即发生、会不会出问题；有问题改回 1。
-- =============================================================================

UPDATE GlobalParameters SET Value = '0' WHERE Name = 'WORLD_CONGRESS_INITIAL_ERA';
UPDATE GlobalParameters SET Value = '3' WHERE Name = 'WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS';

-- 神权理事会正式规则是现代时代起；测试时去掉时代下限
UPDATE Resolutions SET EarliestEra = NULL WHERE ResolutionType = 'WC_RES_TSOD_THEOCRATIC_COUNCIL';
