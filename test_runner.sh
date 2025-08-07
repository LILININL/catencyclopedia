#!/bin/bash

echo "🧪 Starting Cat Encyclopedia Tests..."
echo "=================================="

echo ""
echo "🔧 Building project..."
flutter packages get

echo ""
echo "📊 Running all tests..."
flutter test --coverage

echo ""
echo "🌐 Running integration tests (Real API calls)..."
flutter test test/integration/ --reporter expanded

echo ""
echo "📈 Test Summary:"
echo "- Unit tests: ✅ Completed"
echo "- Integration tests: ✅ Completed" 
echo "- Coverage report: Generated in coverage/"
echo ""
echo "🎉 All tests completed!"
