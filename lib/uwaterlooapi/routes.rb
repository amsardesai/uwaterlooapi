class UWaterlooAPI
  module Routes

    # Route Methods

    def self.route(route)
      @@routes ||= []
      @@routes.push route
    end

    # Routes

    route '/foodservices/menu'
    route '/foodservices/notes'
    route '/foodservices/diets'
    route '/foodservices/outlets'
    route '/foodservices/locations'
    route '/foodservices/watcard'
    route '/foodservices/announcements'
    route '/foodservices/products/{product_id}'
    route '/foodservices/{year}/{week}/menu'
    route '/foodservices/{year}/{week}/notes'
    route '/foodservices/{year}/{week}/announcements'
    route '/courses/{subject}'
    route '/courses/{course_id}'
    route '/courses/{class_number}/schedule'
    route '/courses/{subject}/{catalog_number}'
    route '/courses/{subject}/{catalog_number}/schedule'
    route '/courses/{subject}/{catalog_number}/prerequisites'
    route '/courses/{subject}/{catalog_number}/examschedule'
    route '/events'
    route '/events/{site}'
    route '/events/{site}/{id}'
    route '/events/holidays'
    route '/news'
    route '/news/{site}'
    route '/news/{site}/{id}'
    route '/weather/current'
    route '/terms/list'
    route '/terms/{term}/examschedule'
    route '/terms/{term}/{subject}/schedule'
    route '/terms/{term}/{subject}/{catalog_number}/schedule'
    route '/terms/{term}/infosessions'
    route '/resources/tutors'
    route '/resources/printers'
    route '/resources/infosessions'
    route '/resources/goosewatch'
    route '/codes/units'
    route '/codes/terms'
    route '/codes/groups'
    route '/codes/subjects'
    route '/codes/instructions'
    route '/buildings/list'
    route '/buildings/{building_code}'
    route '/buildings/{building}/{room}/courses'
    route '/api/usage'
    route '/api/services'
    route '/api/methods'
    route '/api/versions'
    route '/api/changelog'
    route '/server/time'
    route '/server/codes'
    route '/parking/watpark'
  end
end
