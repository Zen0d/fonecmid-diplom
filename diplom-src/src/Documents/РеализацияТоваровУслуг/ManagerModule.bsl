
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции 

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт 
    //Добавлено ВКМ
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктОбОказанныхУслугах";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оказанных услугах'");
	КомандаПечати.Порядок = 5;
	//Добавлено ВКМ	
КонецПроцедуры  

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт 	
	//Добавлено ВКМ
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктОбОказанныхУслугах");
	Если ПечатнаяФорма <> Неопределено Тогда
	    ПечатнаяФорма.ТабличныйДокумент = ПечатьАктОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати);
	    ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах'");
	    ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ВКМ_ПФ_DOC_АктОбОказанныхУслугах";
	КонецЕсли;
	//Добавлено ВКМ	
КонецПроцедуры 

#КонецОбласти 


#Область СлужебныеПроцедурыИФункции

Функция ПечатьАктОбОказанныхУслугах(МассивОбъектов, ОбъектыПечати)
	//Добавлено ВКМ
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_АктОбОказанныхУслугах";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ВКМ_ПФ_DOC_АктОбОказанныхУслугах");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		ВывестиТовары(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		
        // В табличном документе необходимо задать имя области, в которую был 
        // выведен объект. Нужно для возможности печати комплектов документов.
        УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
            НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		
	КонецЦикла;	
		
	Возврат ТабличныйДокумент;
	//Добавлено ВКМ
КонецФункции   

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	//Добавлено ВКМ
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	               |	РеализацияТоваровУслуг.Номер КАК Номер,
	               |	РеализацияТоваровУслуг.Дата КАК Дата,
	               |	РеализацияТоваровУслуг.Организация КАК Организация,
	               |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	               |	РеализацияТоваровУслуг.Договор КАК Договор,
	               |	РеализацияТоваровУслуг.Услуги.(
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	               |ГДЕ
	               |	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
	//Добавлено ВКМ
КонецФункции 

Процедура ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет)
	//Добавлено ВКМ
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Акт об оказанных услугах  № %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
		
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	//Добавлено ВКМ
КонецПроцедуры 

Процедура ВывестиРеквизитыСторон(ДанныеДокументов, ТабличныйДокумент, Макет)
	//Добавлено ВКМ
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ПредставлениеПоставщика = "Продавец: "+ДанныеДокументов.Организация;
	ПредставлениеПокупателя = "Клиент: "+ДанныеДокументов.Контрагент;
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("ПредставлениеПоставщика", ПредставлениеПоставщика);
	ДанныеПечати.Вставить("ПредставлениеПокупателя", ПредставлениеПокупателя);
	
	ОбластьШапка.Параметры.Заполнить(ДанныеПечати); 
	
	ТабличныйДокумент.Вывести(ОбластьШапка);
	//Добавлено ВКМ
КонецПроцедуры  

Процедура ВывестиТовары(ДанныеДокументов, ТабличныйДокумент, Макет)
	//Добавлено ВКМ
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ВыборкаТовары = ДанныеДокументов.Услуги.Выбрать();
	СуммаИтого = 0;
	Пока ВыборкаТовары.Следующий() Цикл
		ОбластьСтрока.Параметры.Заполнить(ВыборкаТовары);
		ТабличныйДокумент.Вывести(ОбластьСтрока);
		СуммаИтого = СуммаИтого+ВыборкаТовары.Сумма;
	КонецЦикла;
		
	СуммаРубли = Цел(СуммаИтого);
    СуммаКопейки = (СуммаИтого - СуммаРубли);
    
    РублиЧислом     = Формат(СуммаРубли, "ЧДЦ=0; ЧГ=0");
    РублиПрописью   = ЧислоПрописью(СуммаРубли, "Л = ru_RU; НД = Ложь", "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 0");
    КопейкиПрописью = Сред(ЧислоПрописью(СуммаКопейки, "Л = ru_RU; НП = Ложь", ",,,, копейка, копейки, копеек, ж, 2"), 6);
    
    СуммаПрописью = РублиЧислом + " (" + РублиПрописью + ") " + КопейкиПрописью;
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("СуммаИтого",СуммаИтого); 
	ДанныеПечати.Вставить("СуммаПрописью",СуммаПрописью); 
	
	ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	//Добавлено ВКМ	
КонецПроцедуры


#КонецОбласти

#КонецЕсли