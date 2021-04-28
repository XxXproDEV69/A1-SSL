﻿#Если НЕ Клиент Тогда
	
	Функция ВСтрокиПоСсылкам(Ссылки, Отборы = Неопределено) Экспорт
		СоответствиеТипов = А1Э_Массивы.РазбитьПоТипам(А1Э_Массивы.Массив(Ссылки));
		ВСтрокиПоСсылкам = Новый Соответствие;
		Для Каждого Пара Из СоответствиеТипов Цикл
			ВСтрокиПоСсылкамДляТипа = ВСтрокиПоСсылкамОдногоТипа(Пара.Значение, Отборы);
			Для Каждого ПараПоТипу Из ВСтрокиПоСсылкамДляТипа Цикл
				ВСтрокиПоСсылкам.Вставить(ПараПоТипу.Ключ, ПараПоТипу.Значение);
			КонецЦикла;
		КонецЦикла;
		Возврат ВСтрокиПоСсылкам;
	КонецФункции 
	
	Функция ВСтрокиПоСсылкамОдногоТипа(Ссылки, Отборы = Неопределено)
		ВСтрокиПоСсылкам = Новый Соответствие;
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КонтактнаяИнформация.Ссылка КАК Ссылка,
		|	КонтактнаяИнформация.Тип КАК Тип,
		|	КонтактнаяИнформация.Представление КАК Представление,
		|	КонтактнаяИнформация.АдресЭП КАК АдресЭП
		|ИЗ
		|	Справочник__ИмяСправочника__КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Ссылка В(&Ссылки)
		|	И &Условие";
		А1Э_Строки.Подставить(Запрос.Текст, "Справочник__ИмяСправочника__КонтактнаяИнформация", Ссылки[0].Метаданные().ПолноеИмя() + ".КонтактнаяИнформация"); 
		Запрос.УстановитьПараметр("Ссылки", Ссылки);
		Условия = Новый Массив;
		Если Отборы <> Неопределено Тогда
			Для Каждого Отбор Из Отборы Цикл
				Условия.Добавить(Отбор);
			КонецЦикла;
		КонецЕсли;
		А1Э_Запросы.ПодставитьУсловие(Запрос.Текст, "&Условие", Условия);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		РезультатПоСсылкам = А1Э_ТаблицыЗначений.РазбитьПоКолонке(Таблица, "Ссылка");
		Для Каждого Пара Из РезультатПоСсылкам Цикл
			МассивСтрок = Новый Массив;
			Емэйлы = Новый Массив;
			Телефоны = Новый Массив;
			Для Каждого Строка Из Пара.Значение Цикл
				Если Строка.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Тогда
					Емэйлы.Добавить(Строка.АдресЭП);
				ИначеЕсли Строка.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
					Телефоны.Добавить(Строка.Представление);
				Иначе
					МассивСтрок.Добавить(Строка.Представление);
				КонецЕсли;
			КонецЦикла;
			Если Телефоны.Количество() > 0 Тогда
				МассивСтрок.Вставить(0, "тел.: " + СтрСоединить(Телефоны, ", "));
			КонецЕсли;
		    Если Емэйлы.Количество() > 0 Тогда
				МассивСтрок.Вставить(0, "e-mail: " + СтрСоединить(Емэйлы, ", "));
			КонецЕсли;
			ВСтрокиПоСсылкам.Вставить(Пара.Ключ, СтрСоединить(МассивСтрок, Символы.ПС));
		КонецЦикла;
	    Возврат ВСтрокиПоСсылкам;
	КонецФункции 
	
#КонецЕсли

