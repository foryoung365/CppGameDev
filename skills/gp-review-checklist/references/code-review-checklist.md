## 1. Code Quality And Conventions

| ID | Item | Level | Description |
|---|---|---|---|
| 1.1 | Code duplication issues | Critical | Consolidate logic that repeatedly traverses data only to collect the same statistics or results. |
| 1.2 | Code encapsulation | Critical | Encapsulate repetitive logic and avoid hardcoded copy-paste paths; consider abstraction before duplicating code. |
| 1.3 | Code reuse | Advisory | When modifying existing behavior, reuse shared logic where possible and isolate branch-specific logic. |
| 1.4 | Constant usage consistency | Critical | Use one canonical constant for the same meaning; do not mix different constants even when their values match. |
| 1.5 | Variable naming accuracy | Advisory | Keep variable names aligned with actual behavior; rename variables when logic changes. |
| 1.6 | Enum reuse | Advisory | Reuse existing enums instead of adding a new enum with the same meaning. |

## 2. Memory Management

| ID | Item | Level | Description |
|---|---|---|---|
| 2.1 | Allocation and release pairing | Critical | Memory and object allocation must be paired with the correct release path. |
| 2.2 | Memory leak check | Critical | Review object creation and error-path checks carefully to avoid leaks. |
| 2.3 | Player pointer storage | Critical | Avoid storing raw player pointers directly; prefer player IDs or `CAutoLink<CUser>`. |

## 3. Interface Design

| ID | Item | Level | Description |
|---|---|---|---|
| 3.1 | Prefer extending existing interfaces | Advisory | When a new interface is close to an existing one, prefer extending the existing interface. |
| 3.2 | Parameter design optimization | Advisory | When a function accumulates multiple boolean parameters, consider a mask-based design instead. |
| 3.3 | Shared utility placement | Advisory | Keep general utility helpers out of `User`-specific or other narrow domain classes; prefer `BaseFunc.h` when appropriate. |
| 3.4 | LUA interface comments | Critical | New LUA-exported functions must have interface comments, and parameter or return changes must update those comments. |
| 3.5 | ModuleAddition | Advisory | Put module bonus calculation interfaces in `ModuleAddition` unless there is a strong exception. |

## 4. Performance Optimization

| ID | Item | Level | Description |
|---|---|---|---|
| 4.1 | Hot-path interface performance | Critical | High-frequency interfaces for querying character or item attributes must not perform heavy computation. |
| 4.2 | Return-by-reference optimization | Advisory | When returning collections, consider returning by reference to avoid structure copies. |
| 4.3 | Bitflag optimization | Advisory | When skill traits need cross-type relation traversal, consider flag-based lookup optimization. |
| 4.4 | Message batching | Advisory | Batch same-type synchronization messages when possible. |
| 4.5 | Mail optimization | Advisory | When sending multiple rewards, use multiple item slots to reduce mail volume. |
| 4.6 | Client-side calculation | Advisory | Do not push attributes from the server when the client can derive them safely. |

## 5. Database Operations

| ID | Item | Level | Description |
|---|---|---|---|
| 5.1 | Database indexes | Critical | Fields used in `WHERE` conditions should have supporting indexes. |
| 5.2 | `MoveNext` placement | Critical | In `Recordset` iteration, place `MoveNext` in the third clause of the `for` loop to avoid `continue` bugs. |
| 5.3 | Insert performance optimization | Advisory | `insert` is synchronous and expensive; reuse `update` when the scenario allows it. |
| 5.4 | Subtraction ordering rule | Critical | Confirm operand order for subtraction logic; subtraction is not commutative. |

## 6. Business Logic

| ID | Item | Level | Description |
|---|---|---|---|
| 6.1 | Transaction order | Critical | Deduct and mark before granting rewards. |
| 6.2 | Timer rule | Advisory | For timers that should run once per day, prefer fixed trigger times over polling. |
| 6.3 | Daily refresh | Advisory | Avoid midnight-reset assumptions; prefer a date-plus-count model for daily refresh tracking. |
| 6.4 | `KeepEffect` usage | Critical | `KeepEffect` has an upper bound, so increases must not skip segments. |
| 6.5 | Passive skill triggers | Advisory | Constrain passive skill trigger conditions early to avoid unnecessary activations. |

## 7. Event Handling

| ID | Item | Level | Description |
|---|---|---|---|
| 7.1 | Skill event handling | Advisory | Skill learn, forget, and level-up events should use `CMagic::SpecialEffectMagicProcess`. |
| 7.2 | Eudemon star level changes | Advisory | Star level changes should use `ProcessOnEudemonStarLevChanged`. |
| 7.3 | Boundary conditions | Critical | Handle boundary conditions in loop logic to avoid duplicate processing or missed processing. |
| 7.4 | Divide-by-zero | Critical | Check the divisor before division to avoid divide-by-zero crashes. |

## 8. Exceptions And Permissions

| ID | Item | Level | Description |
|---|---|---|---|
| 8.1 | Exception log comments | Advisory | When an abnormal log or external bug is investigated and intentionally left unchanged, add code comments that explain it. |
| 8.2 | Configuration-driven design | Advisory | Prefer configuration over hardcoded types for general-purpose behavior. |
| 8.3 | PM command permissions | Critical | Review PM command changes for actor permissions, target scope, and any required internal-server guard for cross-server PM. |
| 8.4 | `RoleManager` lookup | Critical | When looking up players or eudemons by ID, consider whether the lookup belongs inside the object creation flow. |
