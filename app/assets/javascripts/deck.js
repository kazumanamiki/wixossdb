////////////////////////////////////////////////////////////
//
// デッキ用Setter/Getter
//
////////////////////////////////////////////////////////////



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

// デッキ、ライフバースト、ガードの総数を計算して表示
calcDeckCardCount = function(deck_name) {
	var deck_tab_badge_count = $('#deck-cards-tab a[href = "#'+deck_name+'"] .badge.count');
	var deck_tab_badge_lb = $('#deck-cards-tab a[href = "#'+deck_name+'"] .badge.lifeburst');
	var deck_tab_badge_g = $('#deck-cards-tab a[href = "#'+deck_name+'"] .badge.guard');
	var deck_card_count = 0
	var deck_lb_count = 0
	var deck_g_count = 0
	$('#'+deck_name+' ul').find('li a').each(function() {
		var this_card_count = parseInt($(this).find('.badge').text());
		deck_card_count = deck_card_count + this_card_count
		deck_lb_count = deck_lb_count + (parseInt($(this).attr('card-lb')) * this_card_count);
		deck_g_count = deck_g_count + (parseInt($(this).attr('card-g')) * this_card_count);
	});
	deck_tab_badge_count.text(deck_card_count);
	deck_tab_badge_lb.text(deck_lb_count);
	deck_tab_badge_g.text(deck_g_count);
}

// タブコンテンツにカードを追加
addDeckCard = function(deck_name, card_id, card_name, card_lb, card_g) {
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
		deck_list.append('<li><a href="javascript:void(0)" card-id="'+card_id+'" card-lb="'+card_lb+'" card-g="'+card_g+'"><span class="name">'+card_name+'</span><span class="card-controler pull-right"><span class="controler deck-card-plus glyphicon glyphicon-plus"></span><span class="controler deck-card-minus glyphicon glyphicon-minus"></span><span class="badge">'+1+'</span></span></a></li>');
	}

	// デッキ、ライフバースト、ガードの総数を計算して表示
	calcDeckCardCount(deck_name);

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

	// デッキ、ライフバースト、ガードの総数を計算して表示
	calcDeckCardCount(deck_name);

	// コンテンツの高さの再設定
	fixCardsHeight();
}

// JSONデータを指定デッキに設定
setDeckCards = function(deck_name, data) {
	$.each(data[deck_name], function() {
		for (var i = 0; i < parseInt(this['count']); i++) {
			var lb = (this['lb'] == "1") ? "1" : "0"
			var g = (this['g'] == "1") ? "1" : "0"
			addDeckCard(deck_name, this['id'], this['name'], lb, g);
		}
	});
}

// JSONデータを設定
setDeck = function(data) {
	// デッキ情報の設定
	$('div.panel.cards > h2').attr('deck-id', data['id']);
	$('div.panel.cards > h2 .text').text(data['name']);
	$('div.panel.cards > h2 .comment').text(data['comment']);

	// デッキ操作アイコンの設定
	$('a.deck-delete').attr('href', '/decks/'+data['id']).attr('data-method', 'delete').attr('data-remote', 'true').attr('data-confirm', '削除してよろしいですか？');
	$('a.deck-show').attr('href', '/decks/'+data['id']).attr('target','_blank');

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
	$('a.deck-show').attr('href', 'javascript:void(0)').removeAttr('target');

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

// #deck_lrig ul 配下のliの要素を元にJSON用のカードデータを生成する
buildCardData = function(element) {
	var card = {};
	card['id']    = element.find('a').attr('card-id');
	card['lb']    = element.find('a').attr('card-lb');
	card['g']     = element.find('a').attr('card-g');
	card['name']  = element.find('.name').text();
	card['count'] = element.find('.badge').text();
	return card;
}

// JSONデータ用にデッキのデータを構築する
buildDeckData = function() {
	// JSONデータの作成
	data = {};
	data["lrig_cards"] = [];
	$('#deck_lrig ul').children().each(function() {
		data["lrig_cards"].push(buildCardData($(this)));
	});
	data["base_cards"] = [];
	$('#deck_base ul').children().each(function() {
		data["base_cards"].push(buildCardData($(this)));
	});
	return data;
}

// json形式でデッキの保存を要求
saveDeck = function() {
	if (!isSelectDeck()) { return; } // デッキが選択されていなければ処理中断

	var jsonData = { deck: {
		card_data: buildDeckData()
	} };

	$.ajax({
		type: 'patch',
		url: '/decks/'+getSelectedDeckId(),
		data: JSON.stringify(jsonData),
		contentType: 'application/json',
		dataType: 'json'
	});
}

// デッキ編集用のモーダル表示
showDeckModal = function(id) {
	// エラーをクリア
	$('.deck-error-message-area').html("");
	$('#deck_name').parent().removeClass("has-error");

	// 編集用にアドレス変更＆タイトル変更＆内容変更
	if (id == null) {

		$('#modal_deck_edit form').attr('action', '/decks').attr('method','post');
		$('#modal_deck_edit h4').text("デッキの新規作成");
		$('#deck_name').val('');
		$('#deck_comment').val('');
	} else {
		$('#modal_deck_edit form').attr('action', '/decks/'+id).attr('method','patch');
		$('#modal_deck_edit h4').text("デッキ情報の編集");
		$('#deck_name').val($('div.panel.cards > h2 .text').text());
		$('#deck_comment').val($('div.panel.cards > h2 .comment').text());
	}

	// モーダル表示
	$('#modal_deck_edit').modal('show');
}

////////////////////////////////////////////////////////////
//
// イベント定義
//
////////////////////////////////////////////////////////////
$(function() {

	//////////////////////////////////
	// イベント定義
	//////////////////////////////////
	// メニュークリック
	$(document).on('click', '#bt-show-user-deck', function() {
		$('#deck-table').animate({
			left: 0
		}, 300);

		// クッキー保持（開いている状態）
		$.cookie("deck-open", "1", { path:'/' });
	});

	// 閉じるボタンクリック
	$(document).on('click', '#deck-table .bt-close', function() {
		$('#deck-table').animate({
			left: -($('#deck-table').outerWidth())
		}, 300);

		// クッキー保持（閉じている状態）
		$.cookie("deck-open", "0", { path:'/' });
	});

	// タブクリック
	$(document).on('click', '#deck-cards-tab a', function() {
		$(this).tab('show');

		// クッキー保持（タブ状態）
		$.cookie("deck-tab", $(this).attr('href'), { path:'/' });
	});

	// デッキの新規作成クリック
	$(document).on('click', 'a.deck-new', function() {
		showDeckModal(null);
	});

	// デッキ編集クリック（モーダルポップアップ）
	$(document).on('click', 'a.deck-edit', function() {
		var edit_deck_id = $('div.panel.cards > h2').attr('deck-id');
		if (edit_deck_id != "") {
			showDeckModal(edit_deck_id);
		}
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

		// JSONデータを取得してデッキを設定
		$.getJSON('/decks/'+deck_id, function(data) {
			if (data['status'] == 200) {
				setDeck(data);

				// クッキー保持（選択デッキ）
				$.cookie("deck-select", deck_id, { path:'/' });
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
		var lb = $(this).attr('card-lb');
		var guard = $(this).attr('card-g');
		var name = $(this).attr('card-name');
		var kind = $(this).attr('card-kind');
		switch (kind) {
			case "ルリグ":
			case "アーツ":
				addDeckCard('deck_lrig', id, name, lb, guard);
				break;
			default:
				addDeckCard('deck_base', id, name, lb, guard);
				break;
		}

		// 自動セーブ
		saveDeck();
	});

	// デッキのカードプラスクリック
	$(document).on('click', 'span.deck-card-plus', function() {
		var id = $(this).closest('a').attr('card-id');
		var lb = $(this).closest('a').attr('card-lb');
		var guard = $(this).closest('a').attr('card-g');
		var deck = $(this).closest('.tab-pane').attr('id');
		addDeckCard(deck, id, "", lb, guard);

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

	// カード名クリック
	$(document).on('click', '#deck_lrig span.name', function() {
		var id = $(this).closest('a').attr('card-id');
		var deck_url = "/cards/" + id;
		window.open(deck_url);
	});
	$(document).on('click', '#deck_base span.name', function() {
		var id = $(this).closest('a').attr('card-id');
		var deck_url = "/cards/" + id;
		window.open(deck_url);
	});
});


//////////////////////////////////
// ロード時メソッド
//////////////////////////////////
var ready = function() {

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
	// 要素の入れ替えを可能にする
	//////////////////////////////////
	$('#deck_lrig ul').sortable({
		update: function(event, ui) {
			saveDeck();
		}
	});
	$('#deck_base ul').sortable({
		update: function(event, ui) {
			saveDeck();
		}
	});

	//////////////////////////////////
	// 高さを調整
	//////////////////////////////////
	fixCardsHeight();
}
$(document).ready(ready)
$(document).on('page:load', ready)
