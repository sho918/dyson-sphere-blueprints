module BlueprintsFilters
  extend ActiveSupport::Concern

  included do
    def set_filters
      @filters = {
        search: params[:search],
        tags: (params[:tags] || "").split(", "),
        order: params[:order] || "recent",
        mod_id: params[:mod_id].presence || @mods.first.id,
        mod_version: params[:mod_version].presence || "Any",
      }

      if @filters[:mod_id] && @filters[:mod_id] != "Any"
        @filter_mod = @mods.find { |mod| mod.id == @filters[:mod_id].to_i }
      else
        @filter_mod = @mods.last
      end
    end

    def filter(blueprints)
      # TODO: At some point when we have hundreds of thousands of blueprints, this will need to be optimized

      blueprints = blueprints.tagged_with(@filters[:tags], any: true) if @filters[:tags].present?

      blueprints = blueprints.search_by_title(@filters[:search]) if @filters[:search]&.present?

      blueprints = blueprints.where(mod_id: @filters[:mod_id]) if @filters[:mod_id] && @filters[:mod_id] != "Any"

      if @filters[:mod_version] && @filters[:mod_version] != "Any"
        if @filters[:mod_id]
          mod = Mod.find(@filters[:mod_id])
          compat_list = mod.compatibility_list_for(@filters[:mod_version])
          blueprints = blueprints.where(mod_version: compat_list)
        else
          blueprints = blueprints.where(mod_version: @filters[:mod_version])
        end
      end

      case @filters[:order]
      when "recent"
        blueprints = blueprints.reorder(created_at: :desc)
      when "popular"
        blueprints = blueprints.reorder(cached_votes_total: :desc)
      end

      blueprints
    end
  end
end
