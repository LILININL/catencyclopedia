# 🧪 Testing Guide for Cat Encyclopedia

## Test Structure

```
test/
├── data/
│   └── sources/
│       └── remote_data_source_test.dart     # Mock tests for API calls
├── domain/
│   └── usecases/
│       ├── get_cat_images_test.dart         # Unit tests for usecase
│       ├── get_random_fact_test.dart        # Unit tests for usecase
│       └── get_breed_search_test.dart       # Unit tests for usecase
├── integration/
│   └── cat_api_integration_test.dart        # Real API integration tests
├── test_helper.dart                         # Test utilities
├── test_helper.mocks.dart                   # Generated mocks
└── widget_test.dart                         # Widget tests
```

## Test Types

### 1. Unit Tests 🔧
- **Location**: `test/domain/usecases/`
- **Purpose**: Test business logic in isolation using mocks
- **What they test**:
  - GetCatImages usecase with different parameters
  - GetRandomFact usecase success/failure scenarios  
  - GetBreedSearch usecase with various queries
  - Error handling and edge cases

### 2. Integration Tests 🌐
- **Location**: `test/integration/`
- **Purpose**: Test real API integration end-to-end
- **What they test**:
  - Real API calls to TheCatAPI
  - Data parsing and transformation
  - Network error handling
  - Complete data flow from API → Repository → UseCase

### 3. Data Layer Tests 📊
- **Location**: `test/data/sources/`
- **Purpose**: Test data source layer with mocked HTTP client
- **What they test**:
  - RemoteDataSource methods
  - HTTP request/response handling
  - JSON parsing
  - Error scenarios

## Running Tests

### Quick Start
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests only
flutter test test/integration/

# Run unit tests only  
flutter test test/domain/
```

### Using Scripts
```bash
# Windows
test_runner.bat

# Linux/Mac
./test_runner.sh
```

### VS Code
- Open Run and Debug panel (Ctrl+Shift+D)
- Select desired test configuration:
  - "Run All Tests" - Full test suite with coverage
  - "Run Integration Tests" - Real API tests
  - "Run Unit Tests Only" - Domain layer tests
  - "Run Data Layer Tests" - Data source tests

## Test Features

### Integration Tests ✨
- **Real API Calls**: Tests against actual TheCatAPI endpoints
- **Data Validation**: Verifies complete data structure
- **Network Scenarios**: Tests various API parameters
- **Console Output**: Shows fetched data for verification

Example output:
```
✅ Fetched 5 cat images
📸 First image URL: https://cdn2.thecatapi.com/images/abc123.jpg
🐱 First breed: Bengal
✅ Fetched cat fact: Cats can jump up to 6 times their length.
✅ Found 1 breeds matching "Bengal"
🐱 First breed: Bengal from United States
```

### Unit Tests 🎯
- **Mocked Dependencies**: Fast execution without network calls
- **Edge Cases**: Empty results, network failures, invalid parameters
- **Business Logic**: Validates usecase behavior
- **Error Scenarios**: Tests proper error handling

### Mock Generation
```bash
# Generate mocks (if needed)
flutter packages pub run build_runner build
```

## Test Configuration

### Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.6
```

### API Integration
- Uses real TheCatAPI (api.thecatapi.com)
- Requires internet connection for integration tests
- API key configured in RemoteDataSource
- Rate limiting may apply for extensive testing

## Best Practices

1. **Run Unit Tests First**: Fast feedback loop
2. **Integration Tests for Confidence**: Verify real API behavior  
3. **Mock External Dependencies**: Keep unit tests isolated
4. **Test Edge Cases**: Empty results, network failures
5. **Validate Data Structure**: Ensure proper parsing
6. **Monitor API Usage**: Be mindful of rate limits

## Troubleshooting

### Common Issues
- **Network Failures**: Check internet connection for integration tests
- **API Rate Limits**: Reduce test frequency if hitting limits
- **Mock Generation**: Run `build_runner` if mocks are missing
- **Coverage Reports**: Ensure `--coverage` flag is used

### Debug Mode
```bash
# Verbose test output
flutter test --reporter expanded

# Single test file
flutter test test/integration/cat_api_integration_test.dart -v
```
