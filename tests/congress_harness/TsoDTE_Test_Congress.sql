-- Test switch: makes the World Congress meet quickly and often (WORLD_CONGRESS_INITIAL_ERA changed from the official 2 to 0, MAX_TIME_BETWEEN_MEETINGS from 30 to 3), and removes Theocratic Council's era floor; enable only for testing.
-- To verify: with INITIAL_ERA = 0, whether the first meeting happens immediately and whether anything breaks; if so, change it back to 1.

UPDATE GlobalParameters SET Value = '0' WHERE Name = 'WORLD_CONGRESS_INITIAL_ERA';
UPDATE GlobalParameters SET Value = '3' WHERE Name = 'WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS';

UPDATE Resolutions SET EarliestEra = NULL WHERE ResolutionType = 'WC_RES_TSOD_THEOCRATIC_COUNCIL';
