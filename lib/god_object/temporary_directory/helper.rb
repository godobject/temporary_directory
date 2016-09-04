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

module GodObject
  module TemporaryDirectory

    module Helper
      def self.new(name_prefix: nil,
                   base_directory: nil,
                   temporary_directory_service: Service.new(name_prefix: name_prefix, base_directory: base_directory))

        mixin = Module.new do
          include Helper
        end

        mixin.send(:define_method, :temporary_directory_service) do
          temporary_directory_service
        end

        mixin
      end

      def temporary_directory
        ensure_presence_of_temporary_directory
      end

      def ensure_presence_of_temporary_directory
        @temporary_directory ||= create_temporary_directory!
      end

      def ensure_absence_of_temporary_directory
        @temporary_directory.rmtree if @temporary_directory

        nil
      end

      private

      def create_temporary_directory!
        temporary_directory_service.new
      end

      def temporary_directory_service
        @temporary_directory_service ||= Service.new
      end
    end

  end
end
