require 'pathname'
require 'marcel'

module CarrierWave

  ##
  # SanitizedFile is a base class which provides a common API around all
  # the different quirky Ruby File libraries. It has support for Tempfile,
  # File, StringIO, Merb-style upload Hashes, as well as paths given as
  # Strings and Pathnames.
  #
  # It's probably needlessly comprehensive and complex. Help is appreciated.
  #
  class SanitizedFile
    include CarrierWave::Utilities::FileName

    attr_reader :file

    class << self
      attr_writer :sanitize_regexp

      def sanitize_regexp
        @sanitize_regexp ||= /[^[:word:]\.\-\+]/
      end
    end

    def initialize(file)
      self.file = file
      @content = @content_type = nil
    end

    ##
    # Returns the filename as is, without sanitizing it.
    #
    # === Returns
    #
    # [String] the unsanitized filename
    #
    def original_filename
      return @original_filename if @original_filename
      if @file && @file.respond_to?(:original_filename)
        @file.original_filename
      elsif path
        File.basename(path)
      end
    end

    ##
    # Returns the filename, sanitized to strip out any evil characters.
    #
    # === Returns
    #
    # [String] the sanitized filename
    #
    def filename
      sanitize(original_filename) if original_filename
    end

    alias_method :identifier, :filename

    ##
    # Returns the file's size.
    #
    # === Returns
    #
    # [Integer] the file's size in bytes.
    #
    def size
      if is_path?
        exists? ? File.size(path) : 0
      elsif @file.respond_to?(:size)
        @file.size
      elsif path
        exists? ? File.size(path) : 0
      else
        0
      end
    end

    ##
    # Returns the full path to the file. If the file has no path, it will return nil.
    #
    # === Returns
    #
    # [String, nil] the path where the file is located.
    #
    def path
      return if @file.blank?
      if is_path?
        File.expand_path(@file)
      elsif @file.respond_to?(:path) && !@file.path.blank?
        File.expand_path(@file.path)
      end
    end

    ##
    # === Returns
    #
    # [Boolean] whether the file is supplied as a pathname or string.
    #
    def is_path?
      !!((@file.is_a?(String) || @file.is_a?(Pathname)) && !@file.blank?)
    end

    ##
    # === Returns
    #
    # [Boolean] whether the file is valid and has a non-zero size
    #
    def empty?
      @file.nil? || self.size.nil? || (self.size.zero? && !self.exists?)
    end

    ##
    # === Returns
    #
    # [Boolean] Whether the file exists
    #
    def exists?
      self.path.present? && File.exist?(self.path)
    end

    ##
    # Returns the contents of the file.
    #
    # === Returns
    #
    # [String] contents of the file
    #
    def read(*args)
      if args.empty?
        if @content
          @content
        elsif is_path?
          File.open(@file, "rb") {|file| file.read }
        else
          @file.try(:rewind)
          @content = @file.read
          @file.try(:close) unless @file.class.ancestors.include?(::StringIO) || @file.try(:closed?)
          @content
        end
      else
        if is_path?
          @file = File.open(path, "rb")
        elsif @file.is_a?(CarrierWave::Uploader::Base)
          @file = StringIO.new(@file.read)
        end

        @file.read(*args)
      end
    end

    ##
    # Rewinds the underlying file.
    #
    def rewind
      @file.rewind if @file.respond_to?(:rewind)
    end

    ##
    # Moves the file to the given path
    #
    # === Parameters
    #
    # [new_path (String)] The path where the file should be moved.
    # [permissions (Integer)] permissions to set on the file in its new location.
    # [directory_permissions (Integer)] permissions to set on created directories.
    #
    def move_to(new_path, permissions=nil, directory_permissions=nil, keep_filename=false)
      return if self.empty?
      new_path = File.expand_path(new_path)

      mkdir!(new_path, directory_permissions)
      move!(new_path)
      chmod!(new_path, permissions)
      self.file = {tempfile: new_path, filename: keep_filename ? original_filename : nil, content_type: declared_content_type}
      self
    end

    ##
    # Helper to move file to new path.
    #
    def move!(new_path)
      if exists?
        FileUtils.mv(path, new_path) unless File.identical?(new_path, path)
      else
        File.open(new_path, "wb") { |f| f.write(read) }
      end
    end

    ##
    # Creates a copy of this file and moves it to the given path. Returns the copy.
    #
    # === Parameters
    #
    # [new_path (String)] The path where the file should be copied to.
    # [permissions (Integer)] permissions to set on the copy
    # [directory_permissions (Integer)] permissions to set on created directories.
    #
    # === Returns
    #
    # @return [CarrierWave::SanitizedFile] the location where the file will be stored.
    #
    def copy_to(new_path, permissions=nil, directory_permissions=nil)
      return if self.empty?
      new_path = File.expand_path(new_path)

      mkdir!(new_path, directory_permissions)
      copy!(new_path)
      chmod!(new_path, permissions)
      self.class.new({tempfile: new_path, content_type: declared_content_type})
    end

    ##
    # Helper to create copy of file in new path.
    #
    def copy!(new_path)
      if exists?
        FileUtils.cp(path, new_path) unless new_path == path
      else
        File.open(new_path, "wb") { |f| f.write(read) }
      end
    end

    ##
    # Removes the file from the filesystem.
    #
    def delete
      FileUtils.rm(self.path) if exists?
    end

    ##
    # Returns a File object, or nil if it does not exist.
    #
    # === Returns
    #
    # [File] a File object representing the SanitizedFile
    #
    def to_file
      return @file if @file.is_a?(File)
      File.open(path, "rb") if exists?
    end

    ##
    # Returns the content type of the file.
    #
    # === Returns
    #
    # [String] the content type of the file
    #
    def content_type
      @content_type ||=
        identified_content_type ||
        declared_content_type ||
        guessed_safe_content_type ||
        Marcel::MimeType::BINARY
    end

    ##
    # Sets the content type of the file.
    #
    # === Returns
    #
    # [String] the content type of the file
    #
    def content_type=(type)
      @content_type = type
    end

    ##
    # Used to sanitize the file name. Public to allow overriding for non-latin characters.
    #
    # === Returns
    #
    # [Regexp] the regexp for sanitizing the file name
    #
    def sanitize_regexp
      CarrierWave::SanitizedFile.sanitize_regexp
    end

  private

    def file=(file)
      if file.is_a?(Hash)
        @file = file["tempfile"] || file[:tempfile]
        @original_filename = file["filename"] || file[:filename]
        @declared_content_type = file["content_type"] || file[:content_type] || file["type"] || file[:type]
      else
        @file = file
        @original_filename = nil
        @declared_content_type = nil
      end
    end

    # create the directory if it doesn't exist
    def mkdir!(path, directory_permissions)
      options = {}
      options[:mode] = directory_permissions if directory_permissions
      FileUtils.mkdir_p(File.dirname(path), **options) unless File.exist?(File.dirname(path))
    end

    def chmod!(path, permissions)
      File.chmod(permissions, path) if permissions
    end

    # Sanitize the filename, to prevent hacking
    def sanitize(name)
      name = name.scrub
      name = name.tr("\\", "/") # work-around for IE
      name = File.basename(name)
      name = name.gsub(sanitize_regexp, "_")
      name = "_#{name}" if name =~ /\A\.+\z/
      name = "unnamed" if name.size.zero?
      name.to_s
    end

    def declared_content_type
      @declared_content_type ||
        if @file.respond_to?(:content_type) && @file.content_type
          Marcel::MimeType.for(declared_type: @file.content_type.to_s.chomp)
        end
    end

    # Guess content type from its file extension. Limit what to be returned to prevent spoofing.
    def guessed_safe_content_type
      return unless path

      type = Marcel::Magic.by_path(original_filename).to_s
      type if type.start_with?('text/') || type.start_with?('application/json')
    end

    def identified_content_type
      with_io do |io|
        mimetype_by_magic = Marcel::Magic.by_magic(io)
        mimetype_by_path = Marcel::Magic.by_path(path)

        return nil if mimetype_by_magic.nil?

        if mimetype_by_path&.child_of?(mimetype_by_magic.type)
          mimetype_by_path.type
        else
          mimetype_by_magic.type
        end
      end
    rescue Errno::ENOENT
      nil
    end

    def with_io(&block)
      if file.is_a?(IO)
        begin
          yield file
        ensure
          file.try(:rewind)
        end
      elsif path
        File.open(path, &block)
      end
    end
  end # SanitizedFile
end # CarrierWave
