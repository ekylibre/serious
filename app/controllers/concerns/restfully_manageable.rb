module RestfullyManageable
  extend ActiveSupport::Concern

  module ClassMethods


    # Build standard RESTful actions to manage records of a model
    def manage_restfully(defaults = {})
      name = self.controller_name
      path = self.controller_path
      options = defaults.extract!(:t3e, :redirect_to, :xhr, :destroy_to, :subclass_inheritance, :partial, :multipart, :except, :only, :grids)
      after_save_url    = options[:redirect_to]
      after_destroy_url = options[:destroy_to] || :index
      actions  = [:index, :show, :new, :create, :edit, :update, :destroy]
      actions &= [options[:only]].flatten   if options[:only]
      actions -= [options[:except]].flatten if options[:except]

      record_name = name.to_s.singularize
      model_name  = name.to_s.classify
      model = model_name.constantize

      if after_save_url.blank?
        if instance_methods(true).include?(:show) or actions.include?(:show)
          after_save_url = :show
        else
          after_save_url = :index
        end
      end

      if after_save_url == :show
        after_save_url = "{action: :show, id: @#{record_name}.id}".c
      elsif after_save_url == :index
        after_save_url = "{action: :index}".c
      elsif after_save_url.is_a?(CodeString)
        after_save_url.gsub!(/RECORD/, "@#{record_name}")
      elsif after_save_url.is_a?(Hash)
        after_save_url = after_save_url.inspect.gsub(/RECORD/, "@#{record_name}")
      end



      render_form_options = []
      render_form_options << "partial: '#{options[:partial]}'" if options[:partial]
      render_form_options << "multipart: true" if options[:multipart]
      render_form = "render(" + render_form_options.join(", ") + ")"

      t3e_code = ""
      # t3e_code = "t3e(@#{record_name}.attributes"
      # if t3e = options[:t3e]
      #   t3e_code << ".merge(" + t3e.collect{|k,v|
      #     "#{k}: (" + (v.is_a?(Symbol) ? "@#{record_name}.#{v}" : v.inspect.gsub(/RECORD/, '@' + record_name)) + ")"
      #   }.join(", ") + ")"
      # end
      # t3e_code << ")"

      code = ''

      code << "respond_to :html, :xml, :json\n"
      # code << "respond_to :pdf, :odt, :ods, :csv, :docx, :xlsx, :only => [:show, :index]\n"

      if actions.include?(:index)
        code << "def index\n"
        code << "  @#{name} = resource_model.all\n"
        code << "  respond_to do |format|\n"
        code << "    format.html\n"
        code << "    format.xml  { render xml:  resource_model.all }\n"
        code << "    format.json { render json: resource_model.all }\n"
        code << "  end\n"
        code << "end\n"
      end

      if actions.include?(:show)
        code << "def show\n"
        code << "  return unless @#{record_name} = find_and_check\n"
        parents = [self]
        while parents.last.superclass < ActionController::Base
          parents << parents.last.superclass
        end
        lookup = Rails.root.join("app", "views", "{#{parents.map(&:controller_path).join(',')}}")
        if Dir.glob(lookup.join("show.*")).any?
          if options[:subclass_inheritance]
            code << "  if @#{record_name}.type and @#{record_name}.type != '#{model_name}'\n"
            code << "    redirect_to controller: @#{record_name}.type.tableize, action: :show, id: @#{record_name}.id\n"
            code << "    return\n"
            code << "  end\n"
          end
          if options[:grids]
            [options[:grids]].flatten.each do |grid|
              code << "  @#{grid}_grid = initialize_grid(@#{record_name}.#{grid})\n"
            end
          end
          code << "  respond_to do |format|\n"
          code << "    format.html { #{t3e_code} }\n"
          code << "    format.xml  { render xml:  @#{record_name} }\n"
          code << "    format.json { render json: @#{record_name} }\n"
          code << "  end\n"
        elsif Dir.glob(lookup.join("index.*")).any?
          code << "  redirect_to action: :index, '#{name}-id' => @#{record_name}.id\n"
        else
          raise StandardError, "Cannot build a default show action without view for show or index actions in #{parents.map(&:controller_path).to_sentence(locale: :eng)} (#{lookup.join('show.*')})."
        end
        code << "end\n"
      end

      code << "def find_and_check\n"
      code << "  unless record = #{model_name}.find_by(id: params[:id])\n"
      code << "    redirect_to({action: :index}, alert: \"Cannot find #{model_name} #\#{params[:id].inspect}\")\n"
      code << "  end\n"
      code << "  return record\n"
      code << "end\n"


      code << "def resource_model\n"
      code << "  #{model_name}\n"
      code << "end\n"
      code << "private :resource_model\n"

      code << "def permitted_params\n"
      code << "  params.require(:#{record_name}).permit!\n"
      # code << "  params.require(controller_name.singularize).permit!\n"
      code << "end\n"
      code << "private :permitted_params\n"

      if options[:subclass_inheritance]
        if self != Backend::BaseController
          code << "def self.inherited(subclass)\n"
          # TODO inherit from superclass parameters (superclass.manage_restfully_options)
          code << "  subclass.manage_restfully(#{options.inspect})\n"
          code << "end\n"
        end
      end

      if actions.include?(:new)
        code << "def new\n"
        # values = model.accessible_attributes.to_a.inject({}) do |hash, attr|
        columns = model.columns_hash.keys
        columns = columns.delete_if{|c| [:depth, :rgt, :lft, :id, :lock_version, :updated_at, :updater_id, :creator_id, :created_at].include?(c.to_sym) }
        values = columns.map(&:to_sym).uniq.inject({}) do |hash, attr|
          hash[attr] = "params[:#{attr}]".c unless attr.blank? or attr.to_s.match(/_attributes$/)
          hash
        end.merge(defaults).collect{|k,v| "#{k}: (#{v.inspect})"}.join(", ")
        code << "  @#{record_name} = resource_model.new(#{values})\n"
        # code << "  @#{record_name} = resource_model.new(permitted_params)\n"
        if xhr = options[:xhr]
          code << "  if request.xhr?\n"
          code << "    render partial: #{xhr.is_a?(String) ? xhr.inspect : 'detail_form'.inspect}\n"
          code << "  else\n"
          code << "    #{render_form}\n"
          code << "  end\n"
        else
          code << "  #{render_form}\n"
        end
        code << "end\n"
      end

      if actions.include?(:create)
        code << "def create\n"
        code << "  @#{record_name} = resource_model.new(permitted_params)\n"
        code << "  if @#{record_name}.save\n"
        code << "    redirect_to(#{after_save_url})\n"
        code << "  else\n"
        code << "    #{render_form}\n"
        code << "  end\n"
        code << "end\n"
      end

      if actions.include?(:edit)
        code << "def edit\n"
        code << "  return unless @#{record_name} = find_and_check\n"
        code << "  #{t3e_code}\n"
        code << "  #{render_form}\n"
        code << "end\n"
      end

      if actions.include?(:update)
        code << "def update\n"
        code << "  return unless @#{record_name} = find_and_check\n"
        code << "  #{t3e_code}\n"
        code << "  @#{record_name}.attributes = permitted_params\n"
        code << "  if @#{record_name}.save\n"
        code << "    redirect_to(#{after_save_url})\n"
        code << "  else\n"
        code << "    #{render_form}\n"
        code << "  end\n"
        code << "end\n"
      end

      if actions.include?(:destroy)

        if after_destroy_url == :index
          after_destroy_url = "{controller: :'#{path}', action: :index}".c
        elsif after_destroy_url.is_a?(CodeString)
          after_destroy_url.gsub!(/RECORD/, "@#{record_name}")
        elsif after_destroy_url.is_a?(Hash)
          after_destroy_url = after_destroy_url.inspect.gsub(/RECORD/, "@#{record_name}")
        end

        # this action deletes or hides an existing record.
        code << "def destroy\n"
        code << "  return unless @#{record_name} = find_and_check\n"
        if model.instance_methods.include?(:destroyable?)
          code << "  if @#{record_name}.destroyable?\n"
          # code << "    resource_model.destroy(@#{record_name}.id)\n"
          code << "    @#{record_name}.destroy\n"
          code << "    notify_success(:record_has_been_correctly_removed)\n"
          code << "  else\n"
          code << "    notify_error(:record_cannot_be_removed)\n"
          code << "  end\n"
        else
          code << "  resource_model.destroy(@#{record_name}.id)\n"
          code << "  notify_success(:record_has_been_correctly_removed)\n"
        end
        # code << "  redirect_to #{after_destroy_url ? after_destroy_url : model.name.underscore.pluralize+'_url'}\n"
        code << "  redirect_to(params[:redirect] || #{after_destroy_url})\n"
        code << "end\n"
      end

      # code.split("\n").each_with_index{|l, x| puts((x+1).to_s.rjust(4)+": "+l)}
      unless Rails.env.production?
        file = Rails.root.join("tmp", "code", "manage_restfully", "#{controller_path}.rb")
        FileUtils.mkdir_p(file.dirname)
        File.open(file, "wb") do |f|
          f.write code
        end
      end

      class_eval(code)
    end


    # Build standard actions to manage records of a model
    def manage_restfully_list(order_by = :id)
      name = self.controller_name
      record_name = name.to_s.singularize
      model = name.to_s.singularize.classify.constantize
      records = model.name.underscore.pluralize
      raise ArgumentError.new("Unknown column for #{model.name}") unless model.columns_hash[order_by]
      code = ''

      sort = ""
      position, conditions = "#{record_name}_position_column", "#{record_name}_conditions"
      sort << "#{position}, #{conditions} = #{record_name}.position_column, #{record_name}.scope_condition\n"
      sort << "#{records} = #{model.name}.where(#{conditions}).order(#{position}+', #{order_by}')\n"
      sort << "#{records}_count = #{records}.count(#{position})\n"
      sort << "unless #{records}_count == #{records}.uniq.count(#{position}) and #{records}.sum(#{position}) == #{records}_count*(#{records}_count+1)/2\n"
      sort << "  #{records}.each_with_index do |#{record_name}, i|\n"
      sort << "    #{model.name}.where(id: #{record_name}.id).update_all(#{position} => i+1)\n"
      sort << "  end\n"
      sort << "end\n"

      code << "def up\n"
      code << "  return unless #{record_name} = find_and_check\n"
      code << "  #{record_name}.move_higher\n"
      code << sort.gsub(/^/, "  ")
      code << "  redirect_to_back\n"
      code << "end\n"

      code << "def down\n"
      code << "  return unless #{record_name} = find_and_check\n"
      code << "  #{record_name}.move_lower\n"
      code << sort.gsub(/^/, "  ")
      code << "  redirect_to_back\n"
      code << "end\n"

      # list = code.split("\n"); list.each_index{|x| puts((x+1).to_s.rjust(4)+": "+list[x])}
      class_eval(code)
    end


    # Build standard actions to manage records of a model
    def manage_restfully_incorporation
      name = self.controller_name
      record_name = name.to_s.singularize
      model = name.to_s.singularize.classify.constantize
      records = model.name.underscore.pluralize
      code = ''

      columns = model.columns_hash.keys
      columns = columns.delete_if{|c| [:depth, :rgt, :lft, :id, :lock_version, :updated_at, :updater_id, :creator_id, :created_at].include?(c.to_sym) }
      values = columns.inject({}) do |hash, attr|
        hash[attr] = "params[:#{attr}]".c unless attr.blank? or attr.to_s.match(/_attributes$/)
        hash
      end.collect{|k,v| "#{k}: (#{v.inspect})"}.join(", ")
      code << "def pick\n"
      code << "  @#{record_name} = resource_model.new(#{values})\n"
      code << "  already_imported_records = #{model}.select(:reference_name).collect(&:reference_name)\n"
      code << "  already_imported = already_imported_records.inject({}) { |ha, val| ha[val] = true; ha}\n"
      code << "  @items = Nomen::#{controller_name.camelcase}.select_without already_imported\n"
      code << "end\n"

      code << "def incorporate\n"
      code << "  reference_name = params[:#{record_name}][:reference_name]\n"
      code << "  if Nomen::#{controller_name.camelcase}[reference_name]\n"
      code << "     begin\n"
      code << "       @#{record_name} = #{model.name}.import_from_nomenclature(reference_name, true)\n"
      code << "       notify_success(:record_has_been_imported)\n"
      code << "     rescue ActiveRecord::RecordInvalid => e\n"
      code << "       notify_error :record_already_imported\n"
      code << "     end\n"
      code << "     redirect_to(params[:redirect] || :back) and return\n"
      code << "  else\n"
      code << "    @#{record_name} = resource_model.new(#{values})\n"
      code << "    @items = Nomen::#{controller_name.camelcase}.selection\n"
      code << "    notify_error :invalid_reference_name\n"
      code << "  end\n"
      code << "  render 'pick'\n"
      code << "end\n"

      class_eval(code)
    end


    #
    def manage_restfully_picture
      name = self.controller_name
      record_name = name.to_s.singularize
      code = ''
      code << "def picture\n"
      code << "  return unless @#{record_name} = find_and_check\n"
      code << "  if @#{record_name}.picture.file?\n"
      code << "    send_file(@#{record_name}.picture.path(params[:style] || :original))\n"
      code << "  else\n"
      code << "    head :not_found\n"
      code << "  end\n"
      code << "end\n"
      class_eval(code)
    end


  end

end
