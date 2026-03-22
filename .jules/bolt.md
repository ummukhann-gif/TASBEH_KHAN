## 2024-03-22 - Debouncing SharedPreferences persist

**Learning:** SharedPreferences `setString` involves disk I/O and JSON encoding. In a counter app where rapid tapping is common, running this synchronously or frequently on every increment can cause severe frame drops and overhead.
**Action:** Always debounce state persistence logic that triggers on rapid user actions (like a tap counter). Add a timer to batch the writes, and importantly, ensure that `dispose()` flushes any pending writes if the timer is still active so data is not lost on sudden app exit or screen unmount.
