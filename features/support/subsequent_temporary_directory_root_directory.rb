# frozen_string_literal: true
=begin
Copyright Alexander E. Fischer <aef@godobject.net>, 2016

This file is part of TemporaryDirectory.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

module SubsequentTemporaryDirectoryRootDirectory
  attr_reader :subsequent_temporary_directory_root_directory

  def create_root_for_subsequent_temporary_directories
    @subsequent_temporary_directory_root_directory = temporary_directory / 'subsequent_temporary_directories'
    @subsequent_temporary_directory_root_directory.mkpath
    @subsequent_temporary_directory_root_directory
  end
end

World(SubsequentTemporaryDirectoryRootDirectory)
