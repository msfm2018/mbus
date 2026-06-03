## Changelog

All notable changes to the mbus package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-15

### Added
- Initial stable release of mbus event bus library
- Comprehensive English documentation for all modules
- Module-based event bus implementation (mEvent)
- Simple global event bus implementation (mSimpleEvent)
- Debug logging utility (mDebugDebug) with emoji indicators
- Complete API reference documentation
- Usage examples and best practices guide
- Troubleshooting guide for common issues
- Performance optimization recommendations
- Support for Flutter SDK >=1.17.0
- Support for Dart SDK >=3.0.6
- Pub.dev publishing metadata and topics
- MIT License

### Features
- **mSimpleEvent**: Global event bus for lightweight applications
  - Event registration and unregistration
  - Event triggering with data payload
  - Listener cleanup and full bus clearing
  
- **mEvent**: Module-based event bus for complex applications
  - Module-level event organization
  - Event namespace isolation
  - UUID tracking for event triggers
  - Duplicate event registration prevention
  - Module-level cleanup
  
- **mDebugDebug**: Debug logging utility
  - Emoji indicators for operation types
  - ISO8601 timestamps
  - Debug mode integration with kDebugMode
  - Selective logging with isEnabled flag

### Documentation
- Complete README.md with quick start guide
- API reference for all public classes and methods
- Usage patterns and examples
- Best practices and recommendations
- Troubleshooting section
- Performance considerations

### Quality
- Zero external dependencies (only Flutter)
- Type-safe implementation using Dart type system
- Comprehensive inline documentation
- Analysis options configured for code quality

### Breaking Changes
None (initial release)

### Deprecated
None

### Removed
None

### Fixed
None

### Security
None reported

## [0.1.1] - 2025-05-19

### Added
- Initial project setup
- Basic event bus implementation
- Flutter package structure

### Notes
- Initial alpha release
- Limited documentation
- Chinese-language comments

---

## Version Numbering

- **Major**: Breaking changes to the public API
- **Minor**: New features that are backward compatible
- **Patch**: Bug fixes and minor improvements

## Migration Guides

### From 0.1.1 to 1.0.0
- All functionality is backward compatible
- Comments have been translated from Chinese to English
- API interfaces remain unchanged
- No breaking changes

## Future Roadmap

### Planned Features for 1.1.0
- Event filtering capabilities
- Listener priority levels
- Async event support
- Event history tracking

### Planned Features for 1.2.0
- Interceptor support
- Event cancellation mechanism
- Listener statistics
- Performance monitoring

### Planned Features for 2.0.0
- Async/await support
- Event middleware pipeline
- Inter-isolate communication
- Event replay functionality

## Known Issues

None currently reported. Please open an issue on GitHub if you discover any problems.

## Support

For issues, feature requests, or questions, please visit:
https://github.com/msfm2018/mbus/issues

## Contributors

- msfm2018 - Initial development and maintenance

## License

This project is licensed under the MIT License - see the LICENSE file for details.
