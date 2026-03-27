---
name: cpp-coding-standards
description: Single authoritative C++ coding standard for this toolkit. Use when writing, reviewing, or refactoring C++ code here.
---

# C++ Coding Standards

This is the single authoritative C++ standard for this toolkit.
It is intended to replace the retired standalone project skill, not just summarize it.
Project-local conventions are the default unless this skill explicitly documents a limited modern C++ exception.

## Precedence

- Follow the established project convention first.
- Do not rewrite project code toward generic modern defaults just because a more modern alternative exists.
- The only limited modern exceptions adopted here are:
  - `nullptr`
  - exactly one of `virtual` / `override` / `final`
  - `using` for new aliases
  - Rule of Zero / Rule of Five as guidance for special members

## Quick Rules

- Keep Hungarian notation and the established project prefixes.
- Keep tabs and the local brace style.
- Use `nullptr` in new or touched code.
- Use `using` for new aliases.
- Keep project-style explicit ownership unless the surrounding module already uses a different local pattern.

## Naming Conventions

Keep the existing project naming system.

### Type Prefixes

- `C` for classes: `CUser`, `CNode`, `CBox`
- `I` for interfaces: `IRole`, `IUser`, `IAdapter`
- `T` for templates: `TEncryptor`
- `ALL_CAPS` is acceptable for project-style data structs such as `PLAYER_INFO`

### Variable Prefixes

Use the existing Hungarian-style prefixes where that pattern is already part of the module.

Basic types:

- `b` for `bool`
- `c` for `char`
- `s` for `short`
- `n` for `int`
- `i64` / `n64` for 64-bit integers
- `l` for `long`
- `uc` for `unsigned char`
- `us` for `unsigned short`
- `un` for `unsigned int`
- `ul` for `unsigned long`
- `f` for `float`
- `d` for `double`
- `dw` for `DWORD`
- `w` for `WORD`
- `bt` for `BYTE`

String and buffer styles:

- `sz` for fixed `char[]` buffers
- `psz` for `char*`
- `ppsz` for `char**`
- `str` for `std::string`

Object styles:

- `obj` for object values
- `r` for references
- `p` for pointers
- `pp` for double pointers
- `e` for enums

Scope prefixes:

- `m_` for members
- `s_` for statics
- `g_` for globals

### Alias Naming

Container alias suffixes remain valid in project code, such as:

- `_VEC`
- `_LST`
- `_MAP`
- `_SET`
- `_DEQ`
- `_QUE`
- `_STK`
- `_MMAP`
- `_HMAP`
- `_PAR`

Keep the project alias naming culture, but use `using` for new aliases.

```cpp
using USER_VEC = std::vector<CUser>;
using USER_MAP = std::map<OBJID, CUser>;
```

## Formatting Rules

- Use tabs for indentation.
- Put opening braces on a new line for functions and control structures.
- Keep the project brace style and do not reformat files toward a generic external style.
- Do not make style compliance depend on `clang-format`.

Example:

```cpp
void Function(int nValue)
{
	if (nValue > 0)
	{
		// ...
	}
	else
	{
		// ...
	}
}
```

### Spacing

- Use spaces around operators.
- Keep `*` attached to the type: `int* pValue`
- Keep `&` attached to the type: `int& rValue`
- No extra spaces inside `[]`
- No space before `()` in function calls

## File And Include Organization

- Keep existing include ordering and file layout conventions.
- Header files should remain self-explanatory and consistent with the project's current structure.
- Source files should include their matching header first when that is already the local pattern.
- Do not reorder or normalize includes just to satisfy an external style ideology.

## Expression And Statement Rules

- Use C++ casts instead of C-style casts.

```cpp
int nValue = static_cast<int>(cValue);
CDerived* pDerived = dynamic_cast<CDerived*>(pBase);
```

- Prefer `bool` over Windows boolean aliases such as `BOOL`.
- Prefer `nullptr` over `NULL` in new or touched code.
- Use explicit pointer comparisons when that improves clarity in legacy-style code.
- Do not assign inside conditions.
- Always keep a `default` branch in `switch` when the local codebase uses that defensive pattern.
- Avoid direct floating-point equality checks unless the value domain makes them safe.

## Function Rules

- Keep interfaces small; five parameters is still a good upper bound unless the surrounding API already establishes otherwise.
- Use `const` on input parameters when the value should not change.
- Pass larger objects by `const&` when that matches the existing project style.
- Keep functions focused; if a function is getting long or handling unrelated responsibilities, split the logic.
- If code allocates memory manually, the ownership and cleanup path must be visible in the function or immediately obvious from the surrounding design.

## Memory Management And Ownership

Preserve the project's explicit ownership style instead of imposing a blanket ban on raw `new` / `delete`.

- Do not mix `new/delete` with `malloc/free`.
- Require clear ownership, matched cleanup, and a visible release path.
- Project helper macros or cleanup patterns may remain in use where the surrounding module already relies on them.
- Setting a pointer to `nullptr` after delete remains acceptable when that is the local defensive pattern.
- Manual assignment or copy logic must guard against self-assignment when resource ownership is involved.

These are defects:

- leaks
- dangling pointers
- double free
- use-after-free
- ambiguous ownership
- hidden cleanup responsibilities

## Class Design

- Prefer initialization lists for constructors.
- Keep data members `private` or `protected` unless the type is intentionally plain project-style data.
- If a type does not own resources or special lifetime behavior, do not add special members just to follow a pattern.
- If a type owns resources or defines special lifetime behavior, handle copy, move, and destruction as a set.
- In legacy code, surrounding modules may still use older copy-suppression techniques; do not rewrite them gratuitously. In new code, prefer explicit modern intent such as `= delete` or a complete special-member implementation when appropriate.

## Buffers, Strings, And Legacy APIs

Project-approved C-style buffers, strings, and pointer-based APIs remain valid.

- Keep `char[]`, `char*`, and project-style string buffers when they match the surrounding module's established pattern.
- Do not force `std::string_view`, `std::vector`, or smart-pointer rewrites into stable legacy code just to modernize style.
- If a C-style buffer API is used, bounds, lifetime, and ownership must still be clear.

## Virtual Function Rules

Use exactly one of `virtual`, `override`, or `final` on a virtual declaration.

- Use `virtual` on base declarations that define the contract.
- Use `override` on derived implementations.
- Use `final` only when intentionally sealing behavior.

These are review defects:

- wrong override signatures
- accidental overloads instead of overrides
- missing virtual destructors in polymorphic hierarchies
- mixed `virtual override` style on the same declaration

## Comments And Documentation

- Prefer clear `//` comments over noisy banner comments inside ordinary logic.
- Keep comments focused on intent, invariants, ownership, or non-obvious flow.
- Do not add comments that merely restate the code.

## Reviewer Guidance

Reviewers should preserve project conventions and block real defects.

Flag:

- lifetime and ownership bugs
- leaks and dangling references/pointers
- double free and use-after-free
- bad override behavior
- new code that still introduces `NULL`
- special-member logic that is inconsistent with actual resource ownership

Do not flag by itself:

- Hungarian notation
- `C` / `I` / `T` prefixes
- `m_` / `s_` / `g_` prefixes
- tab indentation
- project-approved C-style buffers and strings
- non-`clang-format` layout that matches the project style

## Practical Rule

When a generic modern default conflicts with this skill, follow the project convention unless one of the explicitly documented modern rules above applies. Those rules are limited exceptions, not a general style reset.
