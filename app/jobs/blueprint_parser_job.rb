require "benchmark"

class BlueprintParserJob < ApplicationJob
  queue_as :default

  def perform(blueprint_id)
    blueprint = Blueprint.find(blueprint_id)
    case blueprint.mod.name
    when "MultiBuildBeta"
      Parsers::MultibuildBetaBlueprint.new(blueprint).parse!
    when "MultiBuild"
      Parsers::MultibuildBetaBlueprint.new(blueprint).parse!
    when "Dyson Sphere Program"
      Parsers::DysonSphereProgramBlueprint.new(blueprint).parse!
    end
  end
end
