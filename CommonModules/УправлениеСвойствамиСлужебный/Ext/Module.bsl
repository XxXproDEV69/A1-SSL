﻿&Вместо("ПолучитьОсновнойНаборСвойствДляОбъекта")
Функция А1БСП_ПолучитьОсновнойНаборСвойствДляОбъекта(ВладелецСвойств)
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ВладелецСвойств) Тогда
		Ссылка = ВладелецСвойств;
	Иначе
		Ссылка = ВладелецСвойств.Ссылка;
	КонецЕсли;
	Префикс = А1БСП_ДополнительныеРеквизиты.Префикс(Ссылка.Метаданные());
	Если НЕ ЗначениеЗаполнено(Префикс) Тогда
		Результат = ПродолжитьВызов(ВладелецСвойств);
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Наборы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НаборыДополнительныхРеквизитовИСведений КАК Наборы
	|ГДЕ
	|	&Наборы___Префикс_Владелец = &ИмяМетаданных";
	А1Э_Строки.Подставить(Запрос.Текст, "&Наборы___Префикс_Владелец", "Наборы." + Префикс + "_Владелец");
	Запрос.УстановитьПараметр("ИмяМетаданных", Ссылка.Метаданные().ПолноеИмя());
	Возврат А1Э_Запросы.ПервыйРезультат(Запрос);
КонецФункции

// Экспортная версия процедуры получения основного набора свойств.
//
// Параметры:
//  ВладелецСвойств	 - Ссылка,Объект - 
// 
// Возвращаемое значение:
//   - 
//
Функция А1БСП_ОсновнойНаборСвойств(ВладелецСвойств) Экспорт
	Возврат ПолучитьОсновнойНаборСвойствДляОбъекта(ВладелецСвойств);
КонецФункции 

&Вместо("МетаданныеВладельцаЗначенийСвойствНабора")
Функция А1БСП_МетаданныеВладельцаЗначенийСвойствНабора(Ссылка, УчитыватьПометкуУдаления, ТипСсылки)
	Если ТипЗнч(Ссылка) = Тип("Структура") Тогда
		СвойстваСсылки = Ссылка;
	Иначе
		СвойстваСсылки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, А1БСП_КлючевыеРеквизитыНаборов());
	КонецЕсли;
	
	Владелец = Неопределено;
	Для Каждого ИмяРеквизита Из А1БСП_РеквизитыВладельцевНаборов() Цикл
		Владелец = СвойстваСсылки[ИмяРеквизита];
		Если ЗначениеЗаполнено(Владелец) Тогда Прервать; КонецЕсли; 
	КонецЦикла;	
		
	Если ЗначениеЗаполнено(Владелец) Тогда
		ТипСсылки = А1Э_СтандартныеТипы.ТипПолучить(Владелец);
		Возврат А1Э_Метаданные.ОбъектМетаданных(Владелец);
	КонецЕсли;
	Результат = ПродолжитьВызов(Ссылка, УчитыватьПометкуУдаления, ТипСсылки);
	Возврат Результат;
КонецФункции

&Вместо("ЗаполнитьНаборыСДополнительнымиРеквизитами")
Процедура А1БСП_ЗаполнитьНаборыСДополнительнымиРеквизитами(ВсеНаборы, НаборыСРеквизитами)
	Ссылки = ВсеНаборы.ВыгрузитьКолонку("Набор");
	Индекс = Ссылки.Найти(Неопределено);
	Пока Индекс <> Неопределено Цикл
		Ссылки.Удалить(Индекс);
		Индекс = Ссылки.Найти(Неопределено);
	КонецЦикла;
	
	//Добавляем владельцев в получаемые свойства.
	СвойстваСсылок = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Ссылки, А1БСП_КлючевыеРеквизитыНаборов());
	
	Для Каждого СвойстваСсылки Из СвойстваСсылок Цикл
		ТипСсылки = Неопределено;
		МетаданныеВладельца = МетаданныеВладельцаЗначенийСвойствНабора(СвойстваСсылки.Значение, Истина, ТипСсылки);
		
		Если МетаданныеВладельца = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		// Проверка использования дополнительных реквизитов.
		Если МетаданныеВладельца.ТабличныеЧасти.Найти("ДополнительныеРеквизиты") <> Неопределено Тогда
			Строка = ВсеНаборы.Найти(СвойстваСсылки.Ключ, "Набор");
			НаборыСРеквизитами.Добавить(Строка.Набор, Строка.Заголовок);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция А1БСП_КлючевыеРеквизитыНаборов()
	Результат = А1Э_Массивы.Создать("ПометкаУдаления", "ЭтоГруппа", "Предопределенный", "Родитель", "ИмяПредопределенныхДанных", "ИмяПредопределенногоНабора");
	А1Э_Массивы.Добавить(Результат, А1БСП_РеквизитыВладельцевНаборов());
	Возврат Результат;
КонецФункции

Функция А1БСП_РеквизитыВладельцевНаборов() Экспорт
	Результат = Новый Массив;
	Для Каждого Реквизит Из Метаданные.Справочники.НаборыДополнительныхРеквизитовИСведений.Реквизиты Цикл
		Если СтрНайти(Реквизит.Имя, "_Владелец") = 0 Тогда Продолжить; КонецЕсли;
		Результат.Добавить(Реквизит.Имя);
	КонецЦикла;
	Возврат Результат;
КонецФункции 