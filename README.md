## The LengkuasSFL Scripting Language

![Static Badge](https://img.shields.io/badge/License-Apache_License_2.0-blue?style=flat)
![Static Badge](https://img.shields.io/badge/Documentation_License-CC%20BY--SA_4.0-blue?style=flat)

___

LengkuasSFL or simply Lengkuas is an open source, embedded domain specific scripting language for real-time sensor stream filtering and setting measurement scope limits in sensor systems like for example TinyML with sensor fusion.

## The `LenguasSFL` Philosophy

LengkuasSFL aims to follow the following key characteristics:

*   Concise and easily readable
*   Prototyping and production in one single language
*   Can be interpreted or cpmpiled
*   Controlled Concurrency without surprises
*   Memory safety thanks to enforced reference counting
*   easy to grasp, easy to maintain structure
*   FIFO (First-In, First-Out) for staggered data streams

## Who or what is `LengkuasSFL` for?

LengkuasSFL is intended for sensor systems, embedded sensor fusion with TinyML and the engineers and developers working with these technologies. LengkuasSFL can, for example, be used to filter out sensor noise or limit the measurement scope of sensors. It's **not** recommended for beginners to Programming, due to heavy use of low-level concepts like explicit state management, reference counting memory management, pointers and asynchronous operations.

## Building the C++ Parser

### Prerequisites

- **CMake** 3.14 or later
- **C++17 compatible compiler**:
  - **Windows**: Clang 21.1.0+ (recommended) or MSVC 2019+
  - **Linux/macOS**: GCC 8+ or Clang 8+
- **Git** (for automatic ANTLR4 dependency download)
- **Internet connection** (required for first build to download ANTLR4 runtime)
- **ANTLR4** (to generate parser components from the grammar file)

### Build Instructions

1. **Clone the repository**:
   ```bash
   git clone https://github.com/TheSkyler-Dev/LengkuasSFL.git
   cd LengkuasSFL
   ```
2. **Generate Parser and Lexer headers from ANTLR grammar definition**
   ```bash
   cd Grammar
   antlr4 -Dlanguage=Cpp LengkuasSFL.g4
   ```

3. **Navigate to the parser directory**:
   ```bash
   cd Grammar/Parser/src
   ```

4. **Configure the build** (using Ninja generator for best performance):
   ```bash
   cmake -B build -G Ninja .
   ```
   
   Or with default generator:
   ```bash
   cmake -B build .
   ```

5. **Build the project**:
   ```bash
   cmake --build build
   ```

6. **Run the demo parser**:
   ```bash
   # Windows
   .\build\bin\LengkuasDemoParser.exe
   
   # Linux/macOS
   ./build/bin/LengkuasDemoParser
   ```

### Build Notes

- **First build**: Takes ~40 seconds (downloads ANTLR4 4.13.1 runtime)
- **Subsequent builds**: Much faster (dependencies are cached)
- **Clean builds**: Fast (no re-download needed)
- The build system automatically patches ANTLR4 runtime compatibility issues

### Build Output

Successful build produces:
- `LengkuasGrammar` - Static library with parser implementation
- `LengkuasDemoParser` - Demo executable for testing the parser

### Troubleshooting

- **CMake errors**: Ensure CMake 3.14+ is installed
- **Compiler errors**: Make sure you have C++17 support
- **Download failures**: Check internet connection and GitHub access
- **Build failures**: Try cleaning with `rm -rf build` and rebuilding

## Contributing to LengkuasSFL

First of all, thank you for considering contributing to LengkuasSFL. For more information on how to contribute, please see the [Contributing](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/CONTRIBUTING.md) file.

## Documentation License

All documentation for this project is licensed under the Creative Commons Attribution 4.0 International Public License. See the full license in the [DOC\_LICENSE](https://github.com/TheSkyler-Dev/LengkuasSFL/blob/main/Doc/DOC_LICENSE) file.
