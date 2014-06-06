////////////////////////////////////////////////////////////
//
// デッキ用関数定義
//
////////////////////////////////////////////////////////////

// 要素の高さを合わせる
fixHeight = function(css) {
	var target = $(css)
	//target.height(target.parent().height() - target.position().top);
	target.animate({ height: (target.parent().height() - target.position().top) }, 0);
}

// カードのテンツの高さを設定
fixCardsHeight = function() {
	fixHeight('div.panel.cards');
	fixHeight('div.tab.tab-content');
}

// タブコンテンツにカードを追加
addDeckCard = function(deck_name, card_id, card_name) {
	if (!isSelectDeck()) { return; }

	// IDのカードがあるか検索
	var deck_list = $('#'+deck_name+' ul');
	var elm_cards = deck_list.find('li a[card-id = "'+card_id+'"]');
	if (elm_cards.size() != 0) {
		// 存在すればカウントを足す
		var card_count = parseInt(elm_cards.find('.badge').text());
		elm_cards.find('.badge').text(card_count + 1);
	} else {
		// 存在しなければ追加
		deck_list.append('<li><a href="javascript:void(0)" card-id="'+card_id+'"><span class="name">'+card_name+'</span><span class="card-controler pull-right"><span class="controler deck-card-plus glyphicon glyphicon-plus"></span><span class="controler deck-card-minus glyphicon glyphicon-minus"></span><span class="badge">'+1+'</span></span></a></li>');
	}

	// デッキの総数を追加
	var deck_tab_badge = $('#deck-cards-tab a[href = "#'+deck_name+'"] .badge');
	var deck_count = parseInt(deck_tab_badge.text());
	deck_tab_badge.text(deck_count + 1);

	// コンテンツの高さの再設定
	fixCardsHeight();
}

subDeckCard = function(deck_name, card_id) {
	if (!isSelectDeck()) { return; }

	// IDのカードがあるか検索
	var deck_list = $('#'+deck_name+' ul');
	var elm_cards = deck_list.find('li a[card-id = "'+card_id+'"]');
	if (elm_cards.size() != 0) {
		// 存在すればカウントを引く
		var card_count = parseInt(elm_cards.find('.badge').text());
		if (card_count > 1) {
			// カードの枚数を引く
			elm_cards.find('.badge').text(card_count - 1);
		} else {
			// カードを消す
			elm_cards.remove();
		}
	}

	// デッキの総数を引く
	var deck_tab_badge = $('#deck-cards-tab a[href = "#'+deck_name+'"] .badge');
	var deck_count = parseInt(deck_tab_badge.text());
	deck_tab_badge.text(deck_count - 1);

	// コンテンツの高さの再設定
	fixCardsHeight();
}

// JSONデータを指定デッキに設定
setDeckCards = function(deck_name, data) {
	$.each(data[deck_name], function() {
		for (var i = 0; i < parseInt(this['count']); i++) {
			addDeckCard(deck_name, this['id'], this['name']);
		}
	});
}

// JSONデータを設定
setDeck = function(data) {
	// デッキ情報の設定
	$('div.panel.cards > h2').attr('deck-id', data['id']);
	$('div.panel.cards > h2 .text').text(data['name']);

	// デッキ操作アイコンの設定
	$('a.deck-delete').attr('href', '/decks/'+data['id']).attr('data-method', 'delete').attr('data-remote', 'true').attr('data-confirm', '削除してよろしいですか？');
	$('a.deck-show').attr('href', '/decks/'+data['id']).attr('data-confirm', 'ページを移動します。保存していないデータは失われます。よろしいですか？');

	// ルリグデッキのカードを設定
	setDeckCards('deck_lrig', data);
	setDeckCards('deck_base', data);
}

// 指定デッキのクリア
clearDeckCard = function(deck_name) {
	// デッキの総数をクリア
	$('#deck-cards-tab a[href = "#'+deck_name+'"] .badge').text(0);

	// リストのクリア
	$('#'+deck_name+' ul').empty()
}

// デッキ情報のクリア
clearDeck = function() {
	$('div.panel.cards > h2').attr("deck-id", "");
	$('div.panel.cards > h2 .text').text("");

	// デッキ操作アイコンのクリア
	$('a.deck-delete').attr('href', 'javascript:void(0)').removeAttr('data-method').removeAttr('data-remote').removeAttr('data-confirm');
	$('a.deck-show').attr('href', 'javascript:void(0)').removeAttr('data-confirm');

	clearDeckCard('deck_lrig');
	clearDeckCard('deck_base');
}

// デッキIDの取得
getSelectedDeckId = function() {
	return $('div.panel.cards > h2').attr("deck-id");
}

// デッキ名の取得
getSelectedDeckName = function() {
	return $('div.panel.cards > h2 .text').text();
}

// デッキが選択されているかのチェック
isSelectDeck = function() {
	return getSelectedDeckId() != "";
}

buildDeckData = function() {
	// JSONデータの作成
	data = {};
	data["lrig_cards"] = [];
	$('#deck_lrig ul').children().each(function() {
		var card = {};
		card['id'] = $(this).find('a').attr('card-id');
		card['name'] = $(this).find('.name').text();
		card['count'] = $(this).find('.badge').text();
		data["lrig_cards"].push(card);
	});
	data["base_cards"] = [];
	$('#deck_base ul').children().each(function() {
		var card = {};
		card['id'] = $(this).find('a').attr('card-id');
		card['name'] = $(this).find('.name').text();
		card['count'] = $(this).find('.badge').text();
		data["base_cards"].push(card);
	});
	return data;
}

saveDeck = function() {
	if (!isSelectDeck()) { return; } // デッキが選択されていなければ処理中断

	var jsonData = { deck: {
		name: getSelectedDeckName(),
		card_data: buildDeckData()
	} };

	$.ajax({
		type: 'patch',
		url: '/decks/'+getSelectedDeckId(),
		data: JSON.stringify(jsonData),
		contentType: 'application/json'
	});
}



////////////////////////////////////////////////////////////
//
// ロート時＆イベント定義
//
////////////////////////////////////////////////////////////
var ready = function() {

	//////////////////////////////////
	// イベント定義
	//////////////////////////////////
	// メニュークリック
	$(document).on('click', '#bt-show-user-deck', function() {
		$('#deck-table').animate({
			left: 0
		}, 300);

		// クッキー保持（開いている状態）
		$.cookie("deck-open", "1");
	});

	// 閉じるボタンクリック
	$(document).on('click', '#deck-table .bt-close', function() {
		$('#deck-table').animate({
			left: -($('#deck-table').outerWidth())
		}, 300);

		// クッキー保持（閉じている状態）
		$.cookie("deck-open", "0");
	});

	// タブクリック
	$(document).on('click', '#deck-cards-tab a', function() {
		$(this).tab('show');

		// クッキー保持（タブ状態）
		$.cookie("deck-tab", $(this).attr('href'));
	});

	// デッキの新規作成クリック
	$(document).on('click', 'a.deck-new', function() {
		$('#modal_deck_create').modal('show');
	});

	// デッキの作成ボタンクリック
	// $(document).on('click', '#modal_deck_create input[type="submit"]', function() {
	// 	// 連続クリックできないようにボタンをdisabledにする
	// 	$(this).attr('disabled', 'disabled');
	// });

	// デッキ名クリック（デッキの読み込み）
	$(document).on('click', 'a.deck-make', function() {
		var deck_id = $(this).attr('deck-id');

		// 前の情報をクリア
		clearDeck();

		$.getJSON('/decks/'+deck_id, function(data) {
			if (data['status'] == 200) {
				setDeck(data);

				// クッキー保持（選択デッキ）
				$.cookie("deck-select", deck_id);
			} else {
				alert("デッキが存在しません");
			}
		});
	});

	// カードのデッキ追加クリック（選択しているデッキにカードを追加する）
	$(document).on('click', 'a.card-add-deck', function() {
		if (!isSelectDeck()) {
			alert("追加するデッキを選択して下さい");
			return;
		} // デッキが選択されていなければ処理中断

		var id = $(this).attr('card-id');
		var name = $(this).attr('card-name');
		var kind = $(this).attr('card-kind');
		switch (kind) {
			case "ルリグ":
			case "アーツ":
				addDeckCard('deck_lrig', id, name);
				break;
			default:
				addDeckCard('deck_base', id, name);
				break;
		}

		// 自動セーブ
		saveDeck();
	});

	// デッキのカードプラスクリック
	$(document).on('click', 'span.deck-card-plus', function() {
		var id = $(this).closest('a').attr('card-id');
		var deck = $(this).closest('.tab-pane').attr('id');
		addDeckCard(deck, id, "");

		// 自動セーブ
		saveDeck();
	});

	// デッキのカードマイナスクリック
	$(document).on('click', 'span.deck-card-minus', function() {
		var id = $(this).closest('a').attr('card-id');
		var deck = $(this).closest('.tab-pane').attr('id');
		subDeckCard(deck, id);

		// 自動セーブ
		saveDeck();
	});



	//////////////////////////////////
	// ロード時のタブ復元
	//////////////////////////////////

	// タブを表示していたなら最初から表示
	if ($.cookie("deck-open") == "1") {
		$('#deck-table').css('left', 0);
	}
	if ($.cookie("deck-tab") != null) {
		$('#deck-cards-tab a[href="'+$.cookie("deck-tab")+'"]').tab('show');
	}
	if ($.cookie("deck-select") != null) {
		$('a.deck-make[deck-id="'+$.cookie("deck-select")+'"]').click();
	}

	//////////////////////////////////
	// 高さを調整
	//////////////////////////////////
	fixCardsHeight();
}
$(document).ready(ready)
$(document).on('page:load', ready)
