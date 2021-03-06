require 'ruboto/widget'

ruboto_import_widgets :LinearLayout, :Spinner, :TextView

class SpinnerActivity
  def onCreate(bundle)
    super
    set_title File.basename(__FILE__).chomp('_activity.rb').split('_').
                  map { |s| "#{s[0..0].upcase}#{s[1..-1]}" }.join(' ')

    click_handler = proc do |parent, view, position, id|
      @text_view.text = parent.adapter.get_item(position)
    end

    self.content_view =
        linear_layout :orientation => :vertical, :gravity => :center_horizontal do
          spinner :width => :match_parent, :id => 42
          plain_spinner = spinner :width => :match_parent, :id => 43,
                                  :on_item_selected_listener => click_handler
          plain_spinner.adapter = android.widget.ArrayAdapter.new(self, R::layout::simple_spinner_item)

          # FIXME(uwe): Simplify when we stop supporting Android < 4.0.3
          if android.os.Build::VERSION::SDK_INT < 11
            ['Plain Spinner', 'Plain Item'].each do |i|
              plain_spinner.adapter.add(i)
            end
          else
            plain_spinner.adapter.add_all(['Plain Spinner', 'Plain Item'])
          end
          # EMXIF

          spinner :width => :match_parent, :id => 44,
                  :on_item_selected_listener => click_handler,
                  :adapter => android.widget.ArrayAdapter.new(self, R::layout::simple_spinner_item, ['Adapter Spinner', 'Adapter Item'])
          spinner :width => :match_parent, :id => 45  ,
                  :on_item_selected_listener => click_handler,
                  :list => ['List Spinner', 'List Item']
          spinner :width => :match_parent, :id => 46  ,
                  :on_item_selected_listener => click_handler,
                  :list => ['List Spinner', 'List Item'],
                  :item_layout => R::layout::simple_spinner_dropdown_item
          spinner :width => :match_parent, :id => 47  ,
                  :on_item_selected_listener => click_handler,
                  :list => ['List Spinner', 'List Item'],
                  :item_layout => R::layout::simple_spinner_dropdown_item,
                  :dropdown_layout => R::layout::simple_spinner_item
          @text_view = text_view :text => 'Spinning?', :id => 69, :width => :match_parent,
                                 :gravity => :center, :text_size => 48.0
        end
  end
end
