repo-fixture
============

Build and package up git repositories as test fixtures.

## Installation

`gem install repo-fixture`

## Usage

```ruby
require 'repo-fixture'
```

### Philosophy

Test fixtures are static files that contain data used in tests. For example, you might be writing and testing a YAML parser that needs to recognize various types of YAML data. You could test these various types by creating a number of .yml fixture files that you then feed to your parser.

RepoFixture brings this concept to git repositories. It facilitates creating and packaging the repositories into individual fixture files (currently only zip is supported). RepoFixture can also load fixture files and expand the repo's contents into your temp folder, creating a pristine test environment every time.

### Generating Fixtures

To create a new repo-based fixture:

```ruby
my_fixture = RepoFixture.create do |fixture|
  fixture.copy_files(Dir.glob('path/to/files/**/**')) do |file|
    file.sub('path/to/files', '')  # the path in the zip file itself
  end

  fixture.add_all
  fixture.commit('Committing all files')
end
```

Note that the `fixture` object in the example above responds to all the methods in [`TmpRepo`](https://github.com/camertron/tmp-repo).

Once you've put your fixture repo into the state you want, use the `export` method to generate a fixture file:

```ruby
my_fixture.export('path/to/my_fixture.zip')
```

It's always a good idea to clean up after yourself as well:

```ruby
my_fixture.unlink
```

### Loading Fixtures

Once you've created a fixture file, you might want to load it again:

```ruby
my_fixture = RepoFixture.load('./path/to/my_fixture.zip')
my_fixture.working_dir  # => somewhere in your tmp directory
```

## Requirements

No external requirements.

## Running Tests

`bundle exec rake` should do the trick.

## Authors

* Cameron C. Dutro: http://github.com/camertron
