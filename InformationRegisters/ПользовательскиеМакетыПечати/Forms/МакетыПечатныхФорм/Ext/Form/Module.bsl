﻿
&НаСервере
&После("ПриСозданииНаСервере")
Процедура А1БСП_ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МассивОписаний = Новый Массив;
	А1Э_Формы.ДобавитьОписаниеКомандыИКнопки2(МассивОписаний, "А1БСП_ЗагрузитьМакет", "А1БСП_ЗагрузитьМакет", "Загрузить макет", А1Э_Формы.КоманднаяПанель(ЭтаФорма));
	А1Э_Формы.ДобавитьРеквизитыИЭлементы(ЭтаФорма, МассивОписаний);
КонецПроцедуры

&НаКлиенте 
Процедура А1БСП_ЗагрузитьМакет(Команда)
	А1Э_Файлы.ПоказатьВыборФайла("А1БСП_ЗагрузитьМакетПослеВыбора", ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура А1БСП_ЗагрузитьМакетПослеВыбора(ПутьКФайлуМакета, Контекст) Экспорт
	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуМакета[0]);
	АдресФайлаМакетаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	Строка = Элементы.МакетыПечатныхФорм.ТекущиеДанные;
	ИмяОбъектаМетаданныхМакета = Строка.ИмяОбъектаМетаданныхМакета;
	
	ЧастиИмени = СтрРазделить(ИмяОбъектаМетаданныхМакета, ".");
	ИмяМакета = ЧастиИмени[ЧастиИмени.ВГраница()];
	
	ИмяВладельца = "";
	Для НомерЧасти = 0 По ЧастиИмени.ВГраница()-1 Цикл
		Если Не ПустаяСтрока(ИмяВладельца) Тогда
			ИмяВладельца = ИмяВладельца + ".";
		КонецЕсли;
		ИмяВладельца = ИмяВладельца + ЧастиИмени[НомерЧасти];
	КонецЦикла;

	А1БСП_ЗагрузитьМакетПослеВыбораНаСервере(АдресФайлаМакетаВоВременномХранилище, ИмяВладельца, ИмяМакета);
КонецПроцедуры

&НаСервере
Процедура А1БСП_ЗагрузитьМакетПослеВыбораНаСервере(АдресФайлаМакетаВоВременномХранилище, ИмяВладельца, ИмяМакета)

	Запись = РегистрыСведений.ПользовательскиеМакетыПечати.СоздатьМенеджерЗаписи();
	Запись.Объект = ИмяВладельца;
	Запись.ИмяМакета = ИмяМакета;
	Запись.Использование = Истина;
	Запись.Макет = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресФайлаМакетаВоВременномХранилище), Новый СжатиеДанных(9));
	Запись.Записать();
КонецПроцедуры 