# -*- coding: utf-8 -*-

Plugin.create 'mikutter-hayonero'.to_sym do
    defactivity 'hayonero', 'はよねろ'

    settings 'はよねろ' do
        input 'はよねろ', :mikutter_hayonero_word
        adjustment '間隔 (秒)', :mikutter_hayonero_interval, 1, 60*60
        settings '開始 ≦ 現在≦ 終了 (時) (0から48までいけます)' do
            adjustment '勧告開始 (時)', :mikutter_hayonero_begin, 0, 36
            adjustment '勧告終了 (時)', :mikutter_hayonero_end, 0, 48
        end
    end

    def should_sleep?
        now = Time.now.hour
        return ((UserConfig[:mikutter_hayonero_begin] <= now and now <= UserConfig[:mikutter_hayonero_end]) or
                (UserConfig[:mikutter_hayonero_begin] <= now+24 and now+24 <= UserConfig[:mikutter_hayonero_end]))
    end

    def main
        Reserver.new UserConfig[:mikutter_hayonero_interval] do
            if UserConfig[:mikutter_hayonero_end] < UserConfig[:mikutter_hayonero_begin]
                activity :hayonero, 'mikutter-hayonero : 区間の設定がおかしいよ'
            end
            if should_sleep?
                activity :hayonero, UserConfig[:mikutter_hayonero_word]
            end
            main
        end
    end

    on_boot do |service|
        UserConfig[:mikutter_hayonero_word] ||= 'はよねろ'
        UserConfig[:mikutter_hayonero_interval] ||= 30
        UserConfig[:mikutter_hayonero_begin] ||= 24
        UserConfig[:mikutter_hayonero_end] ||= 28
        main
    end
end
