module ActionView #:nodoc:
module Helpers #:nodoc:

  module States
    US        = ["Alabama","Alaska","Arizona","Arkansas","California","Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana","Maine","Maryland","Massachusetts","Michigan","Minnesota","Mississippi","Missouri","Montana","Nebraska","Nevada","New Hampshire","New Jersey","New Mexico","New York","North Carolina","North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico","Rhode Island","South Carolina","South Dakota","Tennessee","Texas","Utah","Vermont","Virginia","Washington","Washington D.C.","West Virginia","Wisconsin","Wyoming"]
    INDIA     = ["Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chhattisgarh","New Delhi","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Orissa""Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttaranchal","Uttar Pradesh","West Bengal"]
    CANADA    = ["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland","Northwest Territories","Nova Scotia","Nunavut","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"]
    AUSTRALIA = ["Australian Capital Territory","New South Wales","Northern Territory","Queensland","South Australia","Tasmania","Victoria","Western Australia"]
    SPAIN     = ["Alava","Albacete","Alicante","Almeria","Asturias","Avila","Badajoz","Barcelona","Burgos","Caceres","Cadiz","Cantrabria","Castellon","Ceuta","Ciudad Real","Cordoba","Cuenca","Girona","Granada","Guadalajara","Guipuzcoa","Huelva","Huesca","Islas Baleares","Jaen","La Coruna","Leon","Lleida","Lugo","Madrid","Malaga","Melilla","Murcia","Navarra","Ourense","Palencia","Palmas, Las","Pontevedra","Rioja, La","Salamanda","Santa Cruz de Tenerife","Segovia","Sevila","Soria","Tarragona","Teruel","Toledo","Valencia","Valladolid","Vizcaya","Zamora","Zaragoza"]
    UGANDA    = ["Abim","Adjumani","Amolatar","Amuria","Apac","Arua","Budaka","Bugiri","Bukwa","Bulisa","Bundibugyo","Bushenyi","Busia","Busiki","Butaleja","Dokolo","Gulu","Hoima","Ibanda","Iganga","Jinja","Kaabong","Kabale","Kabarole","Kaberamaido","Kabingo","Kalangala","Kaliro","Kampala","Kamuli","Kamwenge","Kanungu","Kapchorwa","Kasese","Katakwi","Kayunga","Kibale","Kiboga","Kilak","Kiruhura","Kisoro","Kitgum","Koboko","Kotido","Kumi","Kyenjojo","Lira","Luwero","Manafwa","Maracha","Masaka","Masindi","Mayuge","Mbale","Mbarara","Mityana","Moroto","Moyo","Mpigi","Mubende","Mukono","Nakapiripirit","Nakaseke","Nakasongola","Nebbi","Ntungamo","Oyam","Pader","Pallisa","Rakai","Rukungiri","Sembabule","Sironko","Soroti","Tororo","Wakiso","Yumbe"]
    FRANCE    = ["Alsace","Aquitaine","Auvergne","Bourgogne","Bretagne","Centre","Champagne-Ardenne","Corse","Franche-Comte","Ile-de-France","Languedoc-Roussillon","Limousin","Lorraine","Midi-Pyrenees","Nord-Pas-de-Calais","Basse-Normandie","Haute-Normandie","Pays de la Loire","Picardie","Poitou-Charentes","Provence-Alpes-Cote d'Azur","Rhone-Alpes"]
    GERMAN    = ["Baden-Wurttemberg","Bayern","Berlin","Brandenburg","Bremen","Hamburg","Hessen","Mecklenburg- Vorpommern","Niedersachsen","Nordrhein-Westfalen","Rhineland- Pflaz","Saarland","Sachsen","Sachsen-Anhalt","Schleswig- Holstein","Thuringen"]
    UK        = ["Avon","Bedfordshire","Berkshire","Buckinghamshire","Cambridgeshire","Cheshire","Cleveland","Cornwall","Cumbria","Derbyshire","Devon","Dorset","Durham","Essex","Gloucestershire","Hampshire","Hereford & Worcester","Hertfordshire","Humberside","Kent","Lancashire","Leicestershire","Lincolnshire","London","Manchester","Merseyside","Norfolk","Northamptonshire","Northumberland","Nottinghamshire","Oxfordshire","Shropshire","Somerset","Staffordshire","Suffolk","Surrey","Sussex","Tyne & Wear","Warwickshire","West Midlands","Wiltshire","Yorkshire"]
    SCOTLAND  = ["Aberdeen City","Aberdeenshire","Angus","Argyll & Bute","Clackmannanshire","Dumfries & Galloway","Dundee City","East Ayrshire","East Dunbartonshire","East Lothian","East Renfrewshire","Edinburgh","Falkirk","Fife","Glasgow","Highland","Inverclyde","Midlothian","Moray","North Ayrshire","North Lanarkshire","Orkney","Perth & Kinross","Renfrewshire","Scottish Borders","Shetland","South Ayrshire","South Lanarkshire","Stirling","West Dunbartonshire","West Lothian","Western Isles"]
    WALES     = ["Aberystwyth","Builth Wells","Brecon Beacons","Cardiff","Caernarfon","Fishguard","Holyhead","Llangollen","Pembrokshire","Snowdonia","Swansea"]
    IRELAND   = ["Dublin","Midlands","Northern Ireland","Outer Dublin","Southeast Ireland","Southwest Ireland","West Ireland"]
    US_POSTAL_CODES = [ "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "AE", "AA", "AP" ]

  end

  module FormOptionsHelper
    # Return select and option tags for the given object and method, using state_options_for_select to generate the list of option tags.
    def state_select(object, method, options = {}, html_options = {})
      options.symbolize_keys!
      options[:country] ||= 'US'
      ActionView::Helpers::InstanceTag.new(object, method, self, options.delete(:object)).to_state_select_tag(options.delete(:country), options, html_options)
    end

    # Returns a string of option tags for states in a country. Supply a state name as +selected+ to
    # have it marked as the selected option tag. 
    #
    # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.

    def state_options_for_select(selected = nil, country = 'US')
      country ||= ''
      country = country.to_s.upcase
      if States.const_defined?(country)
        options_for_select(States.const_get(country), selected)
      else
        raise "States for country (#{country}) don't exist for StateSelect"
      end
    end
  end

  class InstanceTag
    def to_state_select_tag(country, options, html_options)
      options.symbolize_keys!
      html_options.stringify_keys!
      add_default_name_and_id(html_options)
      value = value(object)
      selected_value = options.has_key?(:selected) ? options[:selected] : value
      content_tag(:select, add_options(state_options_for_select(selected_value, country), options, value), html_options)
    end
  end

  class FormBuilder
    def state_select(method, options = {}, html_options = {})
      options[:country] ||= 'US'
      @template.state_select(@object_name, method, options.merge(:object => @object), html_options)
    end
  end

end #Helpers
end #ActionView
