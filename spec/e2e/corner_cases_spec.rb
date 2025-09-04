# frozen_string_literal: true

require 'fileutils'
require 'open3'

RSpec.describe 'End-to-end corner cases', :e2e do
  let(:root) { File.expand_path('../..', __dir__) }
  let(:bin)  { File.join(root, 'bin', 'run.rb') }
  let(:input_path)  { File.join(root, 'spec', 'fixtures', 'input_corner_cases.txt') }
  let(:expect_path) { File.join(root, 'spec', 'fixtures', 'output_corner_cases.txt') }
  let(:tmp_dir)     { File.join(root, 'tmp') }
  let(:out_path)    { File.join(tmp_dir, 'output_corner_cases.txt') }

  before { FileUtils.mkdir_p(tmp_dir) }
  after  { FileUtils.rm_f(out_path) }

  it 'produces the expected output for the corner cases fixture' do
    cmd_env = { 'INPUT_PATH' => input_path, 'OUTPUT_PATH' => out_path }
    stdout, stderr, status = Open3.capture3(cmd_env, bin)

    # Our runner should write to OUTPUT_PATH and be quiet on STDOUT.
    expect(status.exitstatus).to eq(0), "run.rb failed: #{stderr}"
    expect(stdout).to eq('')

    actual  = File.read(out_path).strip
    expectd = File.read(expect_path).strip
    expect(actual).to eq(expectd)
  end
end
