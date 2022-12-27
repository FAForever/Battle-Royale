-- As by convention, we pre-append all LOC keys with 'br_', which is short for 'battle_royale_'. We do
-- this to prevent collisions with LOC keys of the base game and / or of other mods. All mods that
-- use localized strings should add some identifier to their LOC keys.

-- delay keys
br_delay_label = "Королевская битва: время подготовки"
br_delay_help = "Определяет время до начала сужения карты"

br_delay_values_none_text = "Откл."
br_delay_values_very_short_text = "Очень маленькое"
br_delay_values_short_text = "Маленькое"
br_delay_values_medium_text = "Среднее"
br_delay_values_long_text = "Долгое"

br_delay_values_none_help = "Отключает задержку. Сужение карты начинается со старта игры."
br_delay_values_very_short_help = "Сужение карты начинается через 60 секунд после начала игры."
br_delay_values_short_help = "Сужение карты начинается через 120 секунд после начала игры."
br_delay_values_medium_help = "Сужение карты начинается через 240 секунд после начала игры."
br_delay_values_long_help = "Сужение карты начинается через 360 секунд после начала игры."


--type keys
br_type_label = "Тип сужения карты"
br_type_help = "Определяет каким образом карта будет уменьшаться."

br_type_values_random_text = "Случайное"
br_type_values_square_text = "Со всех сторон"
br_type_values_clockwise_text = "По часовой стрелке"
br_type_values_counterclockwise_text = "Против часовой стрелки"

br_type_values_random_help = "Сторона сужения определяется случайно."
br_type_values_square_help = "Сужение происходит одновременно со всех сторон, но площадь сужения каждой из сторон снижена."
br_type_values_clockwise_help = "Сужение происходит по часовой стрелке, начальная сторона определяется случайно."
br_type_values_counterclockwise_help = "Сужение происходит против часовой стрелки, начальная сторона определяется случайно."


--interval keys
br_interval_label = "Интервал сужения"
br_interval_help = "Определяет на сколько быстро сужается карта."

br_interval_values_slow_text = "Медленно"
br_interval_values_medium_text = "Средне"
br_interval_values_fast_text = "Быстро"
br_interval_values_hyper_text = "Очень быстро"

br_interval_values_slow_help = "Карта уменьшается каждые 180 секунд."
br_interval_values_medium_help = "Карта уменьшается каждые 140 секунд."
br_interval_values_fast_help = "Карта уменьшается каждые 100 секунд."
br_interval_values_hyper_help = "Карта уменьшается каждые 60 секунд."


--packages interval keys
br_packages_interval_label = "Интервал появления юнитов"
br_packages_interval_help = "Определяет с какой периодичностью появляются паки нейтральных юнитов."

br_packages_interval_values_off_text = "Откл."
br_packages_interval_values_slow_text = "Медленно"
br_packages_interval_values_medium_text = "Средне"
br_packages_interval_values_fast_text = "Быстро"
br_packages_interval_values_hyper_text = "Оч. быстро"

br_packages_interval_values_off_help = "Отключает появление нейтральных юнитов на карте."
br_packages_interval_values_slow_help = "Паки юнитов появляются каждые 60 секунд."
br_packages_interval_values_medium_help = "Паки юнитов появляются каждые 40 секунд."
br_packages_interval_values_fast_help = "Паки юнитов появляются каждые 20 секунд."
br_packages_interval_values_hyper_help = "Паки юнитов появляются каждые 10 секунд."


--economic packages interval keys
br_eco_packages_interval_label = "Появление экономических юнитов"
br_eco_packages_interval_help = "Определяет с какой периодичностью появляются экономические паки нейтральных юнитов."

br_eco_packages_interval_values_off_text = "Откл."
br_eco_packages_interval_values_slow_text = "Медленно"
br_eco_packages_interval_values_medium_text = "Средне"
br_eco_packages_interval_values_fast_text = "Быстро"
br_eco_packages_interval_values_hyper_text = "Оч. быстро"

br_packages_interval_values_off_help = "Отключает появление экономических юнитов на карте."
br_packages_interval_values_slow_help = "Паки юнитов появляются каждые 60-120 секунд."
br_packages_interval_values_medium_help = "Паки юнитов появляются каждые 40-80 секунд."
br_packages_interval_values_fast_help = "Паки юнитов появляются каждые 20-40 секунд."
br_packages_interval_values_hyper_help = "Паки юнитов появляются каждые 10-20 секунд."


-- com beacon tech level keys
br_beacon_tech_level_label = "Тех уровень командирского маяка"
br_beacon_tech_level_help = "Определяет, маяк какого тех. уровня появится после смерти командира. Чем выше стоимость юнитов убитого игрока в массе, тем выше тех. уровень маяка, но также с уровнем растет и время захвата маяка и стоимость захвата в энергии."

br_beacon_tech_level_values_low_text = "Низкая"
br_beacon_tech_level_values_low_help = "Уровни командирского маяка: т1 - если стоимость юнитов в массе была до 20к, т2 - от 20к до 80к, т3 - от 80к и выше"

br_beacon_tech_level_values_normal_text = "Средняя"
br_beacon_tech_level_values_normal_help = "Уровни командирского маяка: т1 - если стоимость юнитов в массе была до 30к, т2 - от 30к до 100к, т3 - от 100к и выше"

br_beacon_tech_level_values_high_text = "Высокая"
br_beacon_tech_level_values_high_help = "Уровни командирского маяка: т1 - если стоимость юнитов в массе была до 42к, т2 - от 42к до 120к, т3 - от 120к и выше"

br_beacon_tech_level_values_very_high_text = "Оч. высокая"
br_beacon_tech_level_values_very_high_help = "Уровни командирского маяка: т1 - если стоимость юнитов в массе была до 60к, т2 - от 60к до 150к, т3 - от 150к и выше"


--packages curve keys
br_packages_curve_label = "Технологический уровень юнитов"
br_packages_curve_help = "Определяет на сколько быстро повышается технологический уровень юнитов."

br_packages_curve_values_slow_text = "Медленно"
br_packages_curve_values_medium_text = "Средне"
br_packages_curve_values_fast_text = "Быстро"
br_packages_curve_values_hyper_text = "Оч. быстро"

br_packages_curve_values_slow_help = "Т3 юниты появятся на 30 минуте игры."
br_packages_curve_values_medium_help = "Т3 юниты появятся на 25 минуте игры."
br_packages_curve_values_fast_help = "Т3 юниты появятся на 20 минуте игры."
br_packages_curve_values_hyper_help = "Т3 юниты появятся на 15 минуте игры."


--packages amount keys
br_packages_amount_label = "Количество юнитов в паках"
br_packages_amount_help = "Определяет сколько юнитов появится в одном паке."

br_packages_amount_values_normal_text = "Стандартное"
br_packages_amount_values_double_text = "Двойное"

br_packages_amount_values_normal_help = "Стандартное число юнитов в паке."
br_packages_amount_values_double_help = "Двойное число юнитов в паке."


--unit buffer keys
br_unit_buffer_label = "Королевская битва: буфер юнитов"
br_unit_buffer_help = "Определят что будет с юнитами после смерти игрока."

br_unit_buffer_values_neutral_text = "Нейтральная армия"
br_unit_buffer_values_neutral_help = "После поражения игрока, юниты переходят в нейтральную армию и становятся неагрессивными."

br_unit_buffer_values_players_text = "Армия игрока"
br_unit_buffer_values_players_help = "После поражения юниты остаются у игрока, но он теряет над ними контроль. Юниты остаются враждебными к противникам. Не рекомендуется при игре в командах."


-- destruction mode keys
br_destruction_mode_label = "Режим уничтожения юнитов"
br_destruction_mode_help = "Определяет, будет ли юнит вне игровой зоны уничтожен моментально или с течением времени."

br_destruction_mode_values_instantly_text = "Мгновенно"
br_destruction_mode_values_instantly_help = "Любой юнит за пределами игровой зоны будет мгновенно уничтожен."

br_destruction_mode_values_10_sec_text = "10 сек"
br_destruction_mode_values_10_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 10 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_20_sec_text = "20 сек"
br_destruction_mode_values_20_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 20 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_30_sec_text = "30 сек"
br_destruction_mode_values_30_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 30 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_40_sec_text = "40 сек"
br_destruction_mode_values_40_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 40 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_50_sec_text = "50 сек"
br_destruction_mode_values_50_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 50 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_60_sec_text = "60 сек"
br_destruction_mode_values_60_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 60 секунд. По умолчанию регенерация игнорируется."


-- regen keys
br_regen_label = "Реген"
br_regen_help = "Определяет, работает ли регенерация здоровья вне игровой зоны. Юниты с высокой регенерацией будут дольше существовать вне игровой зоны."

br_regen_values_ignore_text = "Игнорировать"
br_regen_values_ignore_help = "Юнит с полным здоровьем вне игровой зоны умрет за время определенное в режиме уничтожения."

br_regen_values_consider_text = "Учитывать"
br_regen_values_consider_help = "Регенерация здоровья будет уменьшать урон от неигровой зоны. Кибранские SACU  апгрейдом на реген могут вообще не получать урона от неигровой зоны."


-- destruction mode keys
br_destruction_mode_label = "Режим уничтожения юнитов"
br_destruction_mode_help = "Определяет, будет ли юнит вне игровой зоны уничтожен моментально или с течением времени."

br_destruction_mode_values_instantly_text = "Мгновенно"
br_destruction_mode_values_instantly_help = "Любой юнит за пределами игровой зоны будет мгновенно уничтожен."

br_destruction_mode_values_10_sec_text = "10 сек"
br_destruction_mode_values_10_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 10 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_20_sec_text = "20 сек"
br_destruction_mode_values_20_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 20 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_30_sec_text = "30 сек"
br_destruction_mode_values_30_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 30 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_40_sec_text = "40 сек"
br_destruction_mode_values_40_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 40 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_50_sec_text = "50 сек"
br_destruction_mode_values_50_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 50 секунд. По умолчанию регенерация игнорируется."

br_destruction_mode_values_60_sec_text = "60 сек"
br_destruction_mode_values_60_sec_help = "Юнит с полным здоровьем вне игровой зоны выживет 60 секунд. По умолчанию регенерация игнорируется."


-- regen keys
br_regen_label = "Реген"
br_regen_help = "Определяет, работает ли регенерация здоровья вне игровой зоны. Юниты с высокой регенерацией будут дольше существовать вне игровой зоны."

br_regen_values_ignore_text = "Игнорировать"
br_regen_values_ignore_help = "Юнит с полным здоровьем вне игровой зоны умрет за время определенное в режиме уничтожения."

br_regen_values_consider_text = "Учитывать"
br_regen_values_consider_help = "Регенерация здоровья будет уменьшать урон от неигровой зоны. Кибранские SACU  апгрейдом на реген могут вообще не получать урона от неигровой зоны."


-- sacu spawn keys
br_sacu_spawn_label = "Спавн сакушек"
br_sacu_spawn_help = "Добавляет к появляющимся экспериментальным единицам ресурсную сакушку одной из трех расс, либо инженерную сакушку серафим."

br_sacu_spawn_values_yes_text = "Да"
br_sacu_spawn_values_yes_help = "Добавить к экспериментальной единице сакушку"

br_sacu_spawn_values_no_text = "Нет"
br_sacu_spawn_values_no_help = "Не добавлять к экспериментальной единице сакушку"


-- naval exps keys
br_naval_exps_label = "Морские экспы"
br_naval_exps_help = "Регулирует возможность появления наземных и воздушных экспериментальных единиц в воде"

br_naval_exps_values_only_naval_text = "Только морские"
br_naval_exps_values_only_naval_help = "В воде появляются только морские эксперименталки"

br_naval_exps_values_fifty_fifty_text = "50 на 50"
br_naval_exps_values_fifty_fifty_help = "В воде по очереди появляется одна морская а затем одна наземная/воздушная эксперименталка"

br_naval_exps_values_more_naval_text = "Больше морских"
br_naval_exps_values_more_naval_help = "В воде две из трех  эксперименталок будут морскими"

br_naval_exps_values_more_other_text = "Больше остальных"
br_naval_exps_values_more_other_help = "В воде две из трех  эксперименталок будут наземными/воздушными"


--ui keys
br_ui_shrinking_start = "Время до начала сужения карты: "
br_ui_shrinking_next = "Время до следующего сужения: "
br_ui_shrinking = "Сужение"

br_ui_battle_royale = "Королевская Битва"
br_ui_help = "Помощь"
br_ui_care_packages = "Паки юнитов"
br_ui_care_packages_time = "Время до следующего появления юнитов: "

br_ui_help_text_1 = "Паки юнитов появляются по всей карте. Они содержат юниты, которые вы можете захватить, зареклеймить или уничтожить. Маяк — это быстрый доступ к паку юнитов. Что бы ни случилось с маяком, происходит и с остальными юнитами."
br_ui_help_text_2 = "Например, если вы захватите маяк, юниты, которые идут с маяком, станут вашими. Радар и разведчики полезны для поиска маяков. Место появления последнего пака юнитов отображается бирюзовым квадратом на предварительном просмотре карты."
br_ui_help_text_3 = "Со временем карта будет уменьшаться. Красная линия показывает, где будет новая граница карты. Все юниты, которые находятся снаружи границы, уничтожаются во время сокращения."

br_ui_commander_beacon = 'Командирский маяк'
br_ui_beacon_info = '%s командир (%s бп) захватит командирский маяк за %s секунд тратя %s энергии в секунду.'
br_ui_conversion_time = 'Командирский маяк перейдет на ступень %s через: '

br_ui_death_info = "%s был убит. Место сметри открыто на карте. Захватите маяк чтобы получить юниты: %s стоимостью %s массы. Или уничтожьте маяк не дав захватить его другим игрокам."


-- units info keys
br_beacon_custom_name = " Захватите чтобы получить юниты: %s шт. стоимостью %s массы"


--unit keys
br_ueb5103_desc = "Маяк пака юнитов"
br_uac1301_desc = "T1 Командирский маяк"
br_xsc1501_desc = "T2 Командирский маяк"
br_xsc1301_desc = "T3 Командирский маяк"


--filling unplayable area keys
br_ui_filling_enable = "Включить"
br_ui_filling_disable = "Отключить"
br_ui_filling_header = "Заполнение опасной зоны"
br_ui_filling_x_size = "Изменить размер Х"
