build:
    swift build

test:
    swift test

release:
    swift build -c release

# Update changelog
changelog:
    cz ch

# Bump version according to changelog
bump: changelog
    cz bump
