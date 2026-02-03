#!/bin/bash
# scripts/setup_hooks.sh
# Per DOC-010 Section 9.2.1

# Create hooks directory
mkdir -p .git/hooks

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

echo "Running pre-commit checks..."

# Check if there are staged Dart files
DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$')

if [ -z "$DART_FILES" ]; then
  echo "No Dart files to check"
  exit 0
fi

# Format check
echo "Checking format..."
dart format --set-exit-if-changed $DART_FILES
if [ $? -ne 0 ]; then
  echo "❌ Format check failed. Run 'dart format .' to fix."
  exit 1
fi
echo "✅ Format check passed"

# Analyze
echo "Running analyzer..."
flutter analyze --no-fatal-infos
if [ $? -ne 0 ]; then
  echo "❌ Analysis failed. Fix the issues above."
  exit 1
fi
echo "✅ Analysis passed"

# Run tests
echo "Running tests..."
flutter test --no-pub
if [ $? -ne 0 ]; then
  echo "❌ Tests failed."
  exit 1
fi
echo "✅ Tests passed"

echo "✅ All pre-commit checks passed!"
exit 0
EOF

chmod +x .git/hooks/pre-commit

echo "Pre-commit hooks installed successfully"
