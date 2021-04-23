### Types Equivalences

| Windows Data Type | Vlang   |
| ----------------- | ------- |
| DWORD             | u32     |
| LPWORD            | &u32    |
| LPWSTR            | &u16    |
| HANDLE            | voidptr |
| bool              | bool    |
| unsigned int      | u32     |

### Directives


### Dealing with strings

```vlang
// to_wide returns &u16, useful to call functions that accepts LPWSTR
"text".to_wide()
// []u16 to string, useful to translate a buffer to a Vlang string
string_from_wide(&hostname[0])
```


### Useful resources
