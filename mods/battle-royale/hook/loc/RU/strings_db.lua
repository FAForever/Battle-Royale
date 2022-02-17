
-- As by convention, we pre-append all LOC keys with 'br_', which is short for 'battle_royale_'. We do
-- this to prevent collisions with LOC keys of the base game and / or of other mods. All mods that
-- use localized strings should add some identifier to their LOC keys.

-- delay keys
br_delay_label="Королевская битва: время подготовки"
br_delay_help="Определяет время до начала сужения карты"

br_delay_values_none_text="Откл."
br_delay_values_very_short_text="Очень маленькое"
br_delay_values_short_text="Маленькое"
br_delay_values_medium_text="Среднее"
br_delay_values_long_text="Долгое"

br_delay_values_none_help="Отключает задержку. Сужение карты начинается со старта игры."
br_delay_values_very_short_help="Сужение карты начинается через 60 секунд после начала игры."
br_delay_values_short_help="Сужение карты начинается через 120 секунд после начала игры."
br_delay_values_medium_help="Сужение карты начинается через 240 секунд после начала игры."
br_delay_values_long_help="Сужение карты начинается через 360 секунд после начала игры."


--type keys
br_type_label="Тип сужения карты"
br_type_help="Определяет каким образом карта будет уменьшаться."

br_type_values_random_text="Случайное"
br_type_values_square_text="Со всех сторон"
br_type_values_clockwise_text="По часовой стрелке"
br_type_values_counterclockwise_text="Против часовой стрелки"

br_type_values_random_help="Сторона сужения определяется случайно."
br_type_values_square_help="Сужение происходит одновременно со всех сторон, но площадь сужения каждой из сторон снижена."
br_type_values_clockwise_help="Сужение происходит по часовой стрелке, начальная сторона определяется случайно."
br_type_values_counterclockwise_help="Сужение происходит против часовой стрелки, начальная сторона определяется случайно."

--interval keys
br_interval_label="Интервал сужения"
br_interval_help="Определяет на сколько быстро сужается карта."

br_interval_values_slow_text="Медленно"
br_interval_values_medium_text="Средне"
br_interval_values_fast_text="Быстро"
br_interval_values_hyper_text="Очень быстро"

br_interval_values_slow_help="Карта уменьшается каждые 180 секунд."
br_interval_values_medium_help="Карта уменьшается каждые 140 секунд."
br_interval_values_fast_help="Карта уменьшается каждые 100 секунд."
br_interval_values_hyper_help="Карта уменьшается каждые 60 секунд."

--packages interval keys
br_packages_interval_label="Интервал появления юнитов"
br_packages_interval_help="Определяет с какой периодичностью появляются паки нейтральных юнитов."

br_packages_interval_values_off_text="Откл."
br_packages_interval_values_slow_text="Медленно"
br_packages_interval_values_medium_text="Средне"
br_packages_interval_values_fast_text="Быстро"
br_packages_interval_values_hyper_text="Оч. быстро"

br_packages_interval_values_off_help="Отключает появление нейтральных юнитов на карте."
br_packages_interval_values_slow_help="Паки юнитов появляются каждые 60 секунд."
br_packages_interval_values_medium_help="Паки юнитов появляются каждые 40 секунд."
br_packages_interval_values_fast_help="Паки юнитов появляются каждые 20 секунд."
br_packages_interval_values_hyper_help="Паки юнитов появляются каждые 10 секунд."


--packages curve keys
br_packages_curve_label="Технологический уровень юнитов"
br_packages_curve_help="Определяет на сколько быстро повышается технологический уровень юнитов."

br_packages_curve_values_slow_text="Медленно"
br_packages_curve_values_medium_text="Средне"
br_packages_curve_values_fast_text="Быстро"
br_packages_curve_values_hyper_text="Оч. быстро"

br_packages_curve_values_slow_help="Т3 юниты появятся на 30 минуте игры."
br_packages_curve_values_medium_help="Т3 юниты появятся на 25 минуте игры."
br_packages_curve_values_fast_help="Т3 юниты появятся на 20 минуте игры."
br_packages_curve_values_hyper_help="Т3 юниты появятся на 15 минуте игры."

--packages amount keys
br_packages_amount_label="Количество юнитов в паках"
br_packages_amount_help="Определяет сколько юнитов появится в одном паке."

br_packages_amount_values_normal_text="Стандартное"
br_packages_amount_values_double_text="Двойное"

br_packages_amount_values_normal_help="Стандартное число юнитов в паке."
br_packages_amount_values_double_help="Двойное число юнитов в паке."

--ui keys
br_ui_shrinking_start="Время до начала сужения карты: "
br_ui_shrinking_next="Время до следующего сужения: "
br_ui_shrinking="Сужение"

br_ui_battle_royale="Королевская Битва"
br_ui_help="Помощь"
br_ui_care_packages="Паки юнитов"
br_ui_care_packages_time="Время до следующего появления юнитов: "

br_ui_help_text_1="Паки юнитов появляются по всей карте. Они содержат юниты, которые вы можете захватить, зареклеймить или уничтожить. Маяк — это быстрый доступ к паку юнитов. Что бы ни случилось с маяком, происходит и с остальными юнитами."
br_ui_help_text_2="Например, если вы захватите маяк, юниты, которые идут с маяком, станут вашими. Радар и разведчики полезны для поиска маяков. Место появления последнего пака юнитов отображается бирюзовым квадратом на предварительном просмотре карты."
br_ui_help_text_3="Со временем карта будет уменьшаться. Красная линия показывает, где будет новая граница карты. Все юниты, которые находятся снаружи границы, уничтожаются во время сокращения."

