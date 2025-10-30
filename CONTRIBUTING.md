# Contributing to XOTown

Thank you for your interest in contributing to XOTown! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Process](#development-process)
- [Coding Guidelines](#coding-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Community](#community)

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on constructive feedback
- Accept responsibility for mistakes
- Prioritize the community's best interests

### Unacceptable Behavior

- Harassment, discriminatory language, or personal attacks
- Publishing others' private information
- Trolling or inflammatory comments
- Any conduct deemed inappropriate in a professional setting

---

## How Can I Contribute?

### Reporting Bugs

Before submitting a bug report:

1. **Check existing issues** to avoid duplicates
2. **Verify it's reproducible** on the latest version
3. **Collect information**:
   - XOTown version (`xotown version`)
   - Operating system and version
   - Steps to reproduce
   - Expected vs actual behavior
   - Relevant logs

Submit bug reports as [GitHub Issues](https://github.com/xotown/xotown-chain/issues) with the `bug` label.

### Suggesting Features

Feature suggestions are welcome! Please:

1. **Check existing proposals** to avoid duplicates
2. **Explain the use case** and problem it solves
3. **Describe the proposed solution** clearly
4. **Consider alternatives** and trade-offs

Submit feature requests as GitHub Issues with the `enhancement` label.

### Contributing Code

We welcome code contributions! Areas that need help:

- Bug fixes
- Performance improvements
- Documentation improvements
- Test coverage
- New features (discuss first!)

---

## Development Process

### Setting Up Development Environment

1. **Prerequisites**:
   - Go 1.23+ ([installation guide](https://golang.org/doc/install))
   - Git
   - Make
   - Linux, macOS, or Windows with WSL2

2. **Clone and build**:
   ```bash
   git clone https://github.com/xotown/xotown-chain.git
   cd xotown-chain
   git checkout xotown-v1.15.11
   make xotown
   ```

3. **Run tests**:
   ```bash
   go test ./...
   ```

### Branch Strategy

- `master`: Latest stable release
- `xotown-v1.15.11`: Current development branch (based on go-ethereum v1.15.11)
- `feature/*`: Feature branches
- `bugfix/*`: Bug fix branches

### Making Changes

1. **Create a branch** from `xotown-v1.15.11`:
   ```bash
   git checkout xotown-v1.15.11
   git pull origin xotown-v1.15.11
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following coding guidelines

3. **Test thoroughly**:
   ```bash
   # Run unit tests
   go test ./...

   # Build
   make xotown

   # Test manually if needed
   ./build/bin/xotown --help
   ```

4. **Commit with clear messages**:
   ```bash
   git add .
   git commit -m "feat: add new feature description"
   ```

---

## Coding Guidelines

### Go Style

Follow the [official Go style guide](https://go.dev/doc/effective_go):

- Use `gofmt` to format code
- Follow Go naming conventions
- Write clear, self-documenting code
- Add comments for exported functions
- Keep functions focused and small

### XOTown-Specific Guidelines

1. **Maintain Ethereum compatibility** where possible
2. **Use XOTown units** (Woti, XOTN) in new code, but keep Ethereum units for compatibility
3. **Update documentation** when changing APIs
4. **Preserve original go-ethereum license headers**
5. **Add XOTown attribution** where significant changes are made

### Commit Message Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style/formatting
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

**Examples**:
```
feat(consensus): reduce Clique block time to 3 seconds
fix(rpc): correct balance conversion in web3.fromWoti
docs(readme): add validator setup instructions
```

---

## Pull Request Process

### Before Submitting

1. **Update documentation** if you changed APIs or behavior
2. **Add/update tests** for your changes
3. **Run all tests** locally
4. **Ensure code compiles** on major platforms
5. **Update CHANGELOG.md** if applicable
6. **Rebase on latest** `xotown-v1.15.11`

### Submitting

1. **Push your branch**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request** on GitHub:
   - Use a clear, descriptive title
   - Reference related issues
   - Describe what changed and why
   - List any breaking changes
   - Include screenshots if UI-related

3. **PR Template**:
   ```markdown
   ## Description
   Brief description of changes

   ## Related Issues
   Fixes #123

   ## Changes Made
   - Change 1
   - Change 2

   ## Testing
   How you tested these changes

   ## Breaking Changes
   Any breaking changes (or "None")

   ## Checklist
   - [ ] Tests pass
   - [ ] Documentation updated
   - [ ] Code follows style guidelines
   - [ ] Commits follow conventional format
   ```

### Review Process

- A maintainer will review your PR within 1-2 weeks
- Address feedback promptly
- Be open to suggestions and discussions
- Once approved, a maintainer will merge

---

## Testing

### Running Tests

```bash
# Run all tests
go test ./...

# Run tests for specific package
go test ./params

# Run tests with coverage
go test -cover ./...

# Run tests with race detection
go test -race ./...

# Verbose output
go test -v ./...
```

### Writing Tests

- Place tests in `*_test.go` files
- Use table-driven tests where appropriate
- Test both success and failure cases
- Aim for >80% code coverage for new code

Example:
```go
func TestXOTownConfig(t *testing.T) {
    tests := []struct {
        name     string
        config   *ChainConfig
        expected uint64
    }{
        {
            name:     "XOTown chain ID",
            config:   XOTownChainConfig,
            expected: 29090,
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            if tt.config.ChainID.Uint64() != tt.expected {
                t.Errorf("expected %d, got %d", tt.expected, tt.config.ChainID.Uint64())
            }
        })
    }
}
```

---

## Community

### Getting Help

- **Discord**: [discord.gg/xotown](https://discord.gg/xotown) - Real-time chat
- **Telegram**: [t.me/xotown](https://t.me/xotown) - Community discussions
- **GitHub Issues**: Technical questions and bug reports
- **Email**: support@xotown.com - General inquiries

### Communication Channels

- **GitHub Discussions**: Long-form discussions, proposals
- **Discord #development**: Development discussions
- **Discord #support**: User support
- **Twitter**: [@xotown_official](https://twitter.com/xotown_official) - Announcements

### Recognition

Contributors are recognized in:
- GitHub Contributors page
- Release notes for significant contributions
- Community spotlights on social media

---

## License

By contributing to XOTown, you agree that your contributions will be licensed under the [GNU Lesser General Public License v3.0](LICENSE).

XOTown is derived from [go-ethereum](https://github.com/ethereum/go-ethereum), which is also licensed under LGPL v3.0.

---

## Questions?

If you have questions about contributing, feel free to:
- Ask in [Discord #development](https://discord.gg/xotown)
- Open a GitHub Discussion
- Email: dev@xotown.com

**Thank you for contributing to XOTown!**
