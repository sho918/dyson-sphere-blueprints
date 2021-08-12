module ApplicationHelper
  GAME_TAGS_PATH = Rails.root.join("app/javascript/data/additionalTags.json")

  def upload_server
    Rails.configuration.upload_server
  end

  def get_game_tag_icon_by_name(name)
    additional_tags = JSON.parse(File.read(GAME_TAGS_PATH))
    # TODO: Refacto in a tag list with icons
    if additional_tags.key?(name.capitalize)
      icon_info = additional_tags[name.capitalize]

      begin
        image_path "game_icons/#{icon_info['iconType']}/#{icon_info['icon']}.png"
      rescue StandardError
        image_path "game_icons/entities/default.png"
      end
    else
      icon_name = Engine::Entities.instance.get_uuid(name) || "default"

      begin
        image_path "game_icons/entities/#{icon_name}.png"
      rescue StandardError
        image_path "game_icons/entities/default.png"
      end
    end
  end

  def get_game_entity_icon_by_uuid(uuid)
    file = uuid.presence || "default"

    begin
      image_path "game_icons/entities/#{file}.png"
    rescue StandardError
      image_path "game_icons/entities/default.png"
    end
  end

  def get_game_recipe_icon_by_uuid(uuid)
    file = uuid.blank? || uuid.zero? ? "default" : uuid

    begin
      image_path "game_icons/recipes/#{file}.png"
    rescue StandardError
      image_path "game_icons/recipes/default.png"
    end
  end

  def pluralize_without_count(count, text)
    if count != 0
      count == 1 ? text.to_s : text.pluralize.to_s
    end
    text
  end
end
