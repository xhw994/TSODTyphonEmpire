-- 测试开关：让世界议会尽快、频繁地开会（WORLD_CONGRESS_INITIAL_ERA 官方 2 改为 0，MAX_TIME_BETWEEN_MEETINGS 官方 30 改为 3），并去掉神权理事会的时代下限；只在测试时启用。
-- 待实证：INITIAL_ERA = 0 时首次开会是否立即发生、会不会出问题；有问题改回 1。

UPDATE GlobalParameters SET Value = '0' WHERE Name = 'WORLD_CONGRESS_INITIAL_ERA';
UPDATE GlobalParameters SET Value = '3' WHERE Name = 'WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS';

UPDATE Resolutions SET EarliestEra = NULL WHERE ResolutionType = 'WC_RES_TSOD_THEOCRATIC_COUNCIL';
