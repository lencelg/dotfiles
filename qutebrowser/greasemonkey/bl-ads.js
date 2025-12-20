function addUrlChangeEvent() {
    history.pushState = (f => function pushState() {
        var ret = f.apply(this, arguments);
        window.dispatchEvent(new Event('pushstate'));
        window.dispatchEvent(new Event('urlchange'));
        return ret;
    })(history.pushState);
 
    history.replaceState = (f => function replaceState() {
        var ret = f.apply(this, arguments);
        window.dispatchEvent(new Event('replacestate'));
        window.dispatchEvent(new Event('urlchange'));
        return ret;
    })(history.replaceState);
 
    window.addEventListener('popstate', () => {
        window.dispatchEvent(new Event('urlchange'))
    });
}
 
 
var menu_ALL = [
        ['menu_isEnableHideTheCarouselImageOnTheLeftSideOfTheHomepage', '隐藏首页左侧轮播图', '隐藏首页左侧轮播图', true]
    ],
    menu_ID = [];
for (let i = 0; i < menu_ALL.length; i++) { // 如果读取到的值为 null 就写入默认值
    if (GM_getValue(menu_ALL[i][0]) == null) {
        GM_setValue(menu_ALL[i][0], menu_ALL[i][3])
    };
}
 
 
// 注册脚本菜单
function registerMenuCommand() {
    if (menu_ID.length >= menu_ALL.length) { // 如果菜单ID数组长度大于等于菜单数组长度，说明不是首次添加菜单，需要卸载所有脚本菜单
        for (let i = 0; i < menu_ID.length; i++) {
            GM_unregisterMenuCommand(menu_ID[i]);
        }
    }
    for (let i = 0; i < menu_ALL.length; i++) { // 循环注册脚本菜单
        menu_ALL[i][3] = GM_getValue(menu_ALL[i][0]);
        menu_ID[i] = GM_registerMenuCommand(`${menu_ALL[i][3]?'✅':'❌'} ${menu_ALL[i][1]}`, function() {
            menu_switch(`${menu_ALL[i][3]}`, `${menu_ALL[i][0]}`, `${menu_ALL[i][2]}`)
        });
    }
}
 
 
// 菜单开关
function menu_switch(menu_status, Name, Tips) {
    if (menu_status == 'true') {
        GM_setValue(`${Name}`, false);
        GM_notification({
            text: `已关闭 [${Tips}] 功能\n（点击刷新网页后生效）`,
            timeout: 3500,
            onclick: function() {
                location.reload();
            }
        });
    } else {
        GM_setValue(`${Name}`, true);
        GM_notification({
            text: `已开启 [${Tips}] 功能\n（点击刷新网页后生效）`,
            timeout: 3500,
            onclick: function() {
                location.reload();
            }
        });
    }
    registerMenuCommand(); // 重新注册脚本菜单
};
 
 
// 返回菜单值
function menu_value(menuName) {
    for (let menu of menu_ALL) {
        if (menu[0] == menuName) {
            return menu[3]
        }
    }
}
 
for (let i = 0; i < menu_ALL.length; i++) { // 如果读取到的值为 null 就写入默认值
    if (GM_getValue(menu_ALL[i][0]) == null) {
        GM_setValue(menu_ALL[i][0], menu_ALL[i][3])
    };
}
registerMenuCommand();
if (window.onurlchange === undefined) {
    addUrlChangeEvent();
} // Tampermonkey v4.11 版本添加的 onurlchange 事件 grant，可以监控 pjax 等网页的 URL 变化
 
// ↑↑↑↑↑↑↑↑↑↑↑↑模板，建议直接复制 //
 
 
 
 
(function() {
    'use strict';
 
    // Core Utilities
    const Utils = {
        injectStyle(css) {
            const style = document.createElement('style');
            style.textContent = css;
            document.head.appendChild(style);
        },
 
        hideElement(element) {
            if (!element) return;
            const hideStyles = {
                'display': 'none !important',
                'visibility': 'hidden !important',
                'opacity': '0 !important',
                'background': 'white !important',
                'color': 'white !important',
                'pointer-events': 'none !important',
                'height': '0 !important',
                'width': '0 !important',
                'overflow': 'hidden !important',
                'position': 'absolute !important',
                'z-index': '-9999 !important',
                'clip': 'rect(0, 0, 0, 0) !important'
            };
 
            Object.entries(hideStyles).forEach(([property, value]) => {
                element.style.setProperty(
                    property,
                    value.replace(' !important', ''),
                    'important'
                );
            });
 
            Array.from(element.children).forEach(child => this.hideElement(child));
            element.onclick = null;
            element.onmouseover = null;
            element.onmouseenter = null;
            element.onmouseleave = null;
        }
    };
 
    // Bilibili General Features
    const BilibiliGeneral = {
        hideLoginPrompts() {
            if (window.location.hostname.includes('bilibili.com')) {
                Utils.injectStyle(`
                    .lazy-img,
                    .login-tip,
                    .vip-login,
                    .vip-login-tip,
                    .login-panel-popover {
                        display: none !important;
                    }
                `);
            }
        },
 
        handleLoginState() {
            if (document.cookie.includes('DedeUserID')) {
                Utils.injectStyle(`
                    .desktop-download-tip {
                        display: none !important;
                    }
                `);
            } else {
                const originAppendChild = Node.prototype.appendChild;
 
                // 打开注释，无法登录。
                Node.prototype.appendChild = function(childElement) {
                    if (childElement.tagName === 'SCRIPT' &&
                        childElement.src.includes("login")) {
                        return null;
                    }
                    return originAppendChild.call(this, childElement);
                };
            }
        },
 
        hideAds() {
            document.querySelectorAll('a[href*="cm.bilibili.com/cm/api"]').forEach(element => {
                const parentCard = element.closest('.bili-video-card');
                if (parentCard) {
                    const originalHeight = parentCard.children[0]?.children[0]?.offsetHeight || 100;
                    const messageDiv = document.createElement('div');
                    messageDiv.style.cssText = `
                        background-color: #f0f0f0;
                        color: #666;
                        padding: 15px;
                        text-align: center;
                        font-size: 14px;
                        height: ${originalHeight}px;
                        min-height: 100px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        box-sizing: border-box;
                    `;
                    messageDiv.textContent = "The AD content is hidden";
                    parentCard.innerHTML = '';
                    parentCard.appendChild(messageDiv);
                }
            });
        }
    };
 
    // Ad Blocking Module
    const AdBlocker = {
        targetSelectors: [
            '#slide-ad-exp', '#slide_ad', '#right-bottom-banner',
            '.pop-live-small-mode.part-1', '.ad-floor-cover.b-img',
            '#bannerAd', '.vcd', 'a[data-loc-id="4331"]',
            '#activity_vote', '.ad-report.video-card-ad-small',
            '.ad-report.ad-floor-exp', '.slide-ad-exp',
            '.activity-m-v1.act-now', '.video-page-special-card-small',
            '.btn-ad', 'div[data-v-2ce37bb8].btn-ad',
            '.palette-button-adcard.is-bottom', '.palette-button-adcard'
        ],
 
        hideAllTargetElements() {
            this.targetSelectors.forEach(selector => {
                document.querySelectorAll(selector)
                    .forEach(element => Utils.hideElement(element));
            });
        },
 
        setupObserver() {
            const observer = new MutationObserver(mutations => {
                mutations.forEach(mutation => {
                    if (mutation.addedNodes.length) {
                        mutation.addedNodes.forEach(node => {
                            if (node.nodeType === 1) {
                                const targets = [
                                    'slide_ad', 'slide-ad-exp', 'ad-report',
                                    'activity-m-v1', 'video-page-special-card-small',
                                    'btn-ad', 'palette-button-adcard'
                                ];
                                if (targets.includes(node.id) ||
                                    targets.some(cls => node.classList.contains(cls))) {
                                    Utils.hideElement(node);
                                }
                                node.querySelectorAll(targets.map(t => `#${t}, .${t}`).join(', '))
                                    .forEach(Utils.hideElement);
                            }
                        });
                    }
                    if (mutation.type === 'attributes') {
                        const targets = mutation.target;
                        const checkList = ['slide_ad', 'slide-ad-exp', 'ad-report',
                            'activity-m-v1', 'video-page-special-card-small',
                            'btn-ad', 'palette-button-adcard'
                        ];
                        if (checkList.includes(targets.id) ||
                            checkList.some(cls => targets.classList.contains(cls))) {
                            Utils.hideElement(targets);
                        }
                    }
                });
            });
 
            observer.observe(document.body, {
                childList: true,
                subtree: true,
                attributes: true,
                attributeFilter: ['style', 'class']
            });
 
            return observer;
        },
 
        initialize() {
            this.hideAllTargetElements();
            const observer = this.setupObserver();
            const interval = setInterval(() => this.hideAllTargetElements(), 1000);
            setTimeout(() => {
                clearInterval(interval);
                observer.disconnect();
            }, 30000);
        }
    };
 
    // Page Specific Features
    const PageSpecific = {
        handleLivePage() {
            // Inject CSS to hide elements
            GM_addStyle(`
             #game-id {
               display: none;
             }
            .gift-panel.base-panel.live-skin-coloration-area.gift-corner-mark-ui {
               display: none;
             }
           `);
 
 
            const {
                hostname,
                pathname
            } = window.location;
            if (hostname === 'live.bilibili.com' && (pathname === '/' || pathname === '')) {
                Utils.injectStyle(`
                    .player-area-ctnr.border-box.p-relative.t-center {
                        display: none !important;
                    }
                `);
                const originalPlay = HTMLMediaElement.prototype.play;
                HTMLMediaElement.prototype.play = function() {
                    const stack = new Error().stack || '';
                    if (stack.includes('home-player.prod.min.js')) {
                        this.pause();
                        this.currentTime = 0;
                        this.removeAttribute('autoplay');
                        return Promise.reject(new DOMException('play() failed'));
                    }
                    return originalPlay.apply(this, arguments);
                };
            }
 
            if (hostname === 't.bilibili.com' && (pathname === '/' || pathname === '')) {
                Utils.injectStyle(`
                    .bili-dyn-ads { display: none !important; }
                `);
            }
        },
 
        handleMainPage() {
            const {
                hostname,
                pathname
            } = window.location;
            if (hostname === 'www.bilibili.com' && (pathname === '/' || pathname === '')) {
                Utils.injectStyle(`
                    .bili-video-card__skeleton.loading_animation,
                    .bili-live-card.is-rcmd.enable-no-interest,
                    .ad-report.ad-floor-exp.left-banner,
                    .floor-single-card,
                    .fixed-card { display: none !important; }
                    .feed-card { margin-top: 0 !important; }
                `);
 
                // .recommended-swipe.grid-anchor,
 
                if (GM_getValue('menu_isEnableHideTheCarouselImageOnTheLeftSideOfTheHomepage', true)) {
                    Utils.injectStyle(`
                    .recommended-swipe,
                    .fixed-card { display: none !important; }
                    .feed-card { margin-top: 0 !important; }
                `);
                }
 
                const selectors = {
                    pseudo: '.bili-video-card.is-rcmd',
                    icons: '.vui_icon.bili-video-card__stats--icon',
                    adFeed: '.bili-video-card__mask .bili-video-card__stats--text'
                };
 
                const isBlocked = element => {
                    if (element.dataset.checked) return element.dataset.blocked === 'true';
                    const content = getComputedStyle(element, '::before').content;
                    const blocked = content.includes('AdGuard') || content.includes('AdBlock');
                    element.dataset.checked = 'true';
                    element.dataset.blocked = blocked;
                    return blocked;
                };
 
                const checkElements = (selector, condition, parentSelector) => {
                    document.querySelectorAll(selector).forEach(el => {
                        const target = parentSelector ? el.closest(parentSelector) : el;
                        if (target && (!condition || condition(el))) {
                            target.style.display = 'none';
                            target.dataset.processed = 'true';
                        }
                    });
                };
 
                const debounce = (fn, delay = 100) => {
                    let timeout;
                    return (...args) => {
                        clearTimeout(timeout);
                        timeout = setTimeout(() => fn(...args), delay);
                    };
                };
 
                const observer = new MutationObserver(debounce(() => {
                    checkElements(selectors.pseudo, el =>
                        isBlocked(el) || [...el.children].some(isBlocked));
                    checkElements(selectors.icons, null, '.bili-video-card');
                    checkElements(selectors.adFeed, el =>
                        el.textContent.includes('广告'), '.bili-video-card__wrap');
                }));
 
                observer.observe(document.body, {
                    subtree: true,
                    childList: true
                });
            }
        },
 
        handleVideoPage() {
            const {
                hostname,
                pathname
            } = window.location;
            if (hostname === 'www.bilibili.com' && pathname.startsWith('/video/')) {
                Utils.injectStyle(`
                  .bpx-player-qoeFeedback,
                  .bili-danmaku-x-guide.bili-danmaku-x-show,
                  .bili-danmaku-x-cmd-shrink,
                  .bili-danmaku-x-link.bili-danmaku-x-show,
                  .bili-danmaku-x-scoreSum.bili-danmaku-x-show,
                  .bili-danmaku-x-vote.bili-danmaku-x-show,
                  .bili-danmaku-x-score.bili-danmaku-x-show,
                  .bili-danmaku-x-guide-all.bili-danmaku-x-guide.bili-danmaku-x-show,
                  .bili-danmaku-x-follow-to-electric.bili-danmaku-x-guide-all.bili-danmaku-x-guide.bili-danmaku-x-show,
                  .ad-report.strip-ad.left-banner,
                  .ad-report.ad-floor-exp.left-banner,
                  .ad-report.ad-floor-exp.right-bottom-banner,
                  .activity-m-v1.act-end,
                  .activity-m-v1.act-now,
                  .video-card-ad-small,
                  .video-page-game-card-small,
                  .slide-ad-exp { display: none !important; }
              `);
            }
        }
    };
 
    // Initialize all modules
    function init() {
        BilibiliGeneral.hideLoginPrompts();
        BilibiliGeneral.handleLoginState();
        BilibiliGeneral.hideAds();
        AdBlocker.initialize();
        PageSpecific.handleLivePage();
        PageSpecific.handleMainPage();
        PageSpecific.handleVideoPage();
    }
 
    init();
})();
