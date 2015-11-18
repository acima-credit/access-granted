require "spec_helper"

describe AccessGranted::Rails::ControllerMethods do
  before(:each) do
    @current_user     = double("User")
    @controller_class = Class.new
    @controller       = @controller_class.new
    allow(@controller_class).to receive(:helper_method).with(:can?, :cannot?, :current_policy)
    @controller_class.send(:include, AccessGranted::Rails::ControllerMethods)
    allow(@controller).to receive(:current_user).and_return(@current_user)
  end

  it 'should have current_policy method returning Policy instance' do
    expect(@controller.current_policy).to be_kind_of(AccessGranted::Policy)
  end

  it 'provides can? and cannot? method delegated to current_policy' do
    expect(@controller.can?(:read, String)).to eq(false)
    expect(@controller.cannot?(:read, String)).to eq(true)
  end

  describe '#authorize!' do
    it 'raises exception when authorization fails' do
      expect { @controller.authorize!(:read, String) }.to raise_error(AccessGranted::AccessDenied)
    end

    it 'returns subject if authorization succeeds' do
      klass  = Class.new do
        include AccessGranted::Policy

        def configure
          role :member, 1 do
            can :read, String
          end
        end
      end
      policy = klass.new(@current_user)
      allow(@controller).to receive(:current_policy).and_return(policy)
      expect(@controller.authorize!(:read, String)).to eq(String)
    end
  end

  describe '#authorize_with_path!' do
    context 'custom path/message' do
      it 'raises exception when authorization fails' do
        expect { @controller.authorize_with_path!(:read, String, '/hello', 'some_error') }.to raise_error(AccessGranted::AccessDeniedWithPath) do |e|
          expect(e.path).to eq '/hello'
          expect(e.message).to eq 'some_error'
          expect(e.action).to eq :read
          expect(e.subject).to eq String
        end
      end
    end
    context 'default path/message' do
      it 'raises exception when authorization fails' do
        expect { @controller.authorize_with_path!(:read, String) }.to raise_error(AccessGranted::AccessDeniedWithPath) do |e|
          expect(e.path).to eq '/'
          expect(e.message).to eq "You don't have permissions to access this page."
        end
      end
    end
    context 'nil path/message' do
      it 'raises exception when authorization fails' do
        expect { @controller.authorize_with_path!(:read, String, nil, nil) }.to raise_error(AccessGranted::AccessDeniedWithPath) do |e|
          expect(e.path).to eq '/'
          expect(e.message).to eq "You don't have permissions to access this page."
        end
      end
    end

    it 'returns subject if authorization succeeds' do
      klass  = Class.new do
        include AccessGranted::Policy

        def configure
          role :member, 1 do
            can :read, String
          end
        end
      end
      policy = klass.new(@current_user)
      allow(@controller).to receive(:current_policy).and_return(policy)
      expect(@controller.authorize_with_path!(:read, String)).to eq(String)
    end
  end
end
