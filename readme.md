# nimCEF

Chromium Embedded Framework(CEF3) wrapper

---

nimCEF is a thin wrapper for CEF3 written in Nim.
Basically, nimCEF is CEF3 C API translated to Nim, therefore
if you know how to use CEF3 C API, using nimCEF is not much different.

Gradually, convenience layer will be added on top of C style API to ease
the development in Nim style and Nim native datatypes will be used whenever possible.

---

###Translation status(CEF3 ver 2623):

| No | Items                 | Windows  | Linux   | Mac OS X | Nim Ver |
|----|-----------------------|----------|---------|----------|---------|
| 1  | CEF3 C API            | complete | ongoing | ongoing  | 0.13.0  |
| 2  | CEF3 C API example    | yes      | no      | no       | 0.13.0  |
| 3  | Simple Client Example | no       | no      | no       | 0.13.0  |
| 4  | CefClient Example     | no       | no      | no       | 0.13.0  |
| 5  | Convenience Layer     | no       | no      | no       | 0.13.0  |