#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, РежимПроведения) 
	
	 // регистр ВКМ_ВзаиморасчетыССотрудниками Расход
    Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
	//наложить блокировку на регистр
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = Выплаты;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Сотрудник", "Сотрудник");
	Блокировка.Заблокировать();

		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВКМ_ВыплатаЗарплатыВыплаты.Сотрудник КАК Сотрудник,
		|	СУММА(ВКМ_ВыплатаЗарплатыВыплаты.Сумма) КАК СуммаДок
		|ПОМЕСТИТЬ ВТ_Док
		|ИЗ
		|	Документ.ВКМ_ВыплатаЗарплаты.Выплаты КАК ВКМ_ВыплатаЗарплатыВыплаты
		|ГДЕ
		|	ВКМ_ВыплатаЗарплатыВыплаты.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ВКМ_ВыплатаЗарплатыВыплаты.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_Док.Сотрудник КАК Сотрудник,
		|	ВТ_Док.СуммаДок КАК СуммаДок,
		|	ЕСТЬNULL(ВКМ_ВзаиморасчетыССотрудникамиОстатки.СуммаОстаток, 0) КАК СуммаНачислено
		|ИЗ
		|	ВТ_Док КАК ВТ_Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ВКМ_ВзаиморасчетыССотрудниками.Остатки(
		|				&МоментВремени,
		|				Сотрудник В
		|					(ВЫБРАТЬ
		|						ВТ_Док.Сотрудник КАК Сотрудник
		|					ИЗ
		|						ВТ_Док КАК ВТ_Док)) КАК ВКМ_ВзаиморасчетыССотрудникамиОстатки
		|		ПО ВТ_Док.Сотрудник = ВКМ_ВзаиморасчетыССотрудникамиОстатки.Сотрудник";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		
		Дефицит = Выборка.СуммаДок - Выборка.СуммаНачислено;
		Если Выборка.СуммаНачислено = 0 Тогда
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Сотрудник: %1, Начислений нет!!!", Выборка.Сотрудник));
			Отказ = Истина;
		ИначеЕсли Дефицит > 0 Тогда 
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Сотрудник: %1, сумма к выплане %2 руб. %3 коп., больше суммы начисления %4 руб. %5 коп., на %6 руб. %7 коп.", Выборка.Сотрудник, Цел(Выборка.СуммаДок),  (Выборка.СуммаДок-Цел(Выборка.СуммаДок))* 100, Цел(Выборка.СуммаНачислено), (Выборка.СуммаНачислено-Цел(Выборка.СуммаНачислено))* 100, Цел(Дефицит), (Дефицит-Цел(Дефицит))* 100));
			Отказ = Истина;
		КонецЕсли;
		
		Если Отказ Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.Добавить();
        Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
        Движение.Период = Дата;
        Движение.Сотрудник = Выборка.Сотрудник;
        Движение.Сумма = Выборка.СуммаДок;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)  
	
	Если Выплаты.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю("Выплоты отсутствуют. Заполните табличную часть!!!");
		Отказ = Истина;
	 КонецЕсли;  
	 
КонецПроцедуры

#КонецОбласти

#КонецЕсли