require "spec_helper"

describe Arrthorizer::Rails::ControllerConcern do
  describe :to_prepare_context do
    let(:controller_class) { Class.new(ApplicationController) }
    let(:expected_context_builder_type) { Arrthorizer::Rails::ControllerContextBuilder }

    it "adds a ControllerContextBuilder to the class" do
      expected_context_builder = an_instance_of(expected_context_builder_type)

      expect {
        controller_class.to_prepare_context do end
      }.to change { controller_class.arrthorizer_context_builder }.to(expected_context_builder)
    end

    context "when we are dealing with a subclassed controller" do
      let(:controller_subclass) { Class.new(controller_class) }

      before :each do
        controller_class.to_prepare_context do end
      end

      it "does not alter the context builder for the superclass" do
        expect {
          controller_subclass.to_prepare_context do end
        }.not_to change { controller_class.arrthorizer_context_builder }
      end
    end

    context "when no configuration block is provided" do
      specify "an Arrthorizer::Rails::ConfigurationError is raised" do
        expect {
          controller_class.to_prepare_context
        }.to raise_error(Arrthorizer::ContextBuilder::ConfigurationError)
      end
    end
  end
end