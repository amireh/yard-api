require 'spec_helper'
require 'tempfile'

describe YARD::Templates::Helpers::HtmlHelper do
  let(:html) { Class.new { include YARD::Templates::Helpers::HtmlHelper }.new }
  let(:included) { Tempfile.new('included') }
  let(:excluded) { Tempfile.new('excluded') }

  before do
    html.singleton_class.class_variable_set(:@@static_pages, nil)
    html.singleton_class.class_variable_set(:@@visible_static_pages, nil)
    set_option('static', [
      {'path' => included.path, 'title' => 'Included'},
      {'path' => excluded.path, 'title' => 'Excluded', 'exclude_from_sidebar' => true}
    ])
  end

  after do
    included.close(true)
    excluded.close(true)
  end

  describe '#visible_static_pages' do
    it 'excludes pages with exclude_from_sidebar option' do
      pages = html.visible_static_pages
      expect(pages.count).to eq(1)
      expect(pages[0][:title]).to eq('Included')
      expect(pages[0][:exclude_from_sidebar]).to be_falsey
    end
  end

  describe '#static_pages' do
    it 'includes pages with exclude_from_sidebar option' do
      pages = html.static_pages
      expect(pages.count).to eq(2)

      page = pages.find { |p| p[:exclude_from_sidebar] }
      expect(page).to_not be_nil
      expect(page[:title]).to eq('Excluded')
    end
  end
end
