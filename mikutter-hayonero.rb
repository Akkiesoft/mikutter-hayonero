# -*- coding: utf-8 -*-

Plugin.create 'mikutter-hayonero'.to_sym do
    defactivity 'hayonero', 'はよねろ'

    def main
        Reserver.new 10 do
            if Time.now.hour < 5 then
                activity :hayonero, 'はよねろ'
            end
            main
        end
    end

    main
end
