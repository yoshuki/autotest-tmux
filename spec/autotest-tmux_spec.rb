require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Autotest::Tmux do
  context 'all added hooks should be called by autotest' do
    Autotest::HOOKS.keys.each do |hook|
      subject { Autotest::ALL_HOOKS }
      it { should include(hook) }
    end
  end
end
