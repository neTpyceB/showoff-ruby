# frozen_string_literal: true

RSpec.describe 'CLI flow' do
  def run_cli(*)
    Open3.capture3('bundle', 'exec', 'bin/toolkit', *)
  end

  it 'searches, renames, and organizes files' do
    Dir.mktmpdir do |directory|
      original = File.join(directory, 'alpha.txt')
      File.write(original, 'alpha')

      search_stdout, search_stderr, search_status = run_cli('search', '--path', directory, '--query', 'alpha')
      rename_stdout, rename_stderr, rename_status = run_cli('rename', '--path', original, '--name', 'report.txt')
      organize_stdout, organize_stderr, organize_status = run_cli('organize', '--path', directory)

      expect(search_status.success?).to be(true)
      expect(search_stdout).to include(original)
      expect(search_stderr).to include("matched #{original}")

      renamed = File.join(directory, 'report.txt')
      expect(rename_status.success?).to be(true)
      expect(rename_stdout).to eq("#{renamed}\n")
      expect(rename_stderr).to include("renamed #{original} -> #{renamed}")

      organized = File.join(directory, 'txt', 'report.txt')
      expect(organize_status.success?).to be(true)
      expect(organize_stdout).to eq("#{organized}\n")
      expect(organize_stderr).to include("organized #{renamed} -> #{organized}")
      expect(File.read(organized)).to eq('alpha')
    end
  end
end
