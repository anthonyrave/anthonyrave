# Makefile for Anthony Rave's PHP project
# Provides commands for static analysis and development tasks

.PHONY: help install phpstan test clean

# Default target
help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	@echo "Installing dependencies..."
	@if command -v composer >/dev/null 2>&1; then \
		composer install; \
	else \
		echo "Error: Composer is not installed. Please install Composer first."; \
		exit 1; \
	fi

phpstan: ## Run PHPStan static analysis
	@echo "Running PHPStan static analysis..."
	@if [ ! -d "vendor" ]; then \
		echo "Dependencies not installed. Running 'make install' first..."; \
		$(MAKE) install; \
	fi
	@if command -v composer >/dev/null 2>&1 && [ -f "vendor/bin/phpstan" ]; then \
		composer run-script phpstan; \
	elif command -v php >/dev/null 2>&1; then \
		echo "PHPStan not installed via Composer, running basic PHP syntax check..."; \
		if find src -name "*.php" -exec php -l {} \; | grep -q "Errors parsing"; then \
			echo "❌ PHP syntax errors found!"; \
			exit 1; \
		else \
			echo "✅ Basic PHP syntax check passed!"; \
		fi; \
	else \
		echo "Error: Neither PHPStan nor PHP is available for analysis."; \
		exit 1; \
	fi

test: phpstan ## Run all tests including PHPStan analysis
	@echo "All tests completed successfully!"

clean: ## Clean generated files
	@echo "Cleaning generated files..."
	@rm -rf vendor/
	@rm -f composer.lock