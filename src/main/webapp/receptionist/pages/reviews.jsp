<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div id="reviews-root">

  <%-- ===== Summary Stats ===== --%>
  <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mt-6 mb-8">

    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
      <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Average Rating</p>
      <div class="flex items-center gap-2">
        <h3 class="text-3xl font-black text-slate-800">4.8</h3>
        <div class="flex text-amber-400">
          <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">star</span>
          <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">star</span>
          <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">star</span>
          <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">star</span>
          <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">star_half</span>
        </div>
      </div>
    </div>

    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
      <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Total Reviews</p>
      <h3 class="text-3xl font-black text-slate-800" id="total-rev-count">0</h3>
    </div>

    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
      <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">Positive Feedback</p>
      <h3 class="text-3xl font-black text-mint">94%</h3>
    </div>

    <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm">
      <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mb-1">New This Week</p>
      <h3 class="text-3xl font-black text-brand-blue">+12</h3>
    </div>

  </div>

  <%-- ===== Filter Bar & Search ===== --%>
  <div class="flex items-center justify-between mb-6">

    <div class="flex items-center bg-white border border-slate-100 rounded-2xl p-1 shadow-sm gap-1">
      <button data-filter="all"
        class="rev-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-brand-blue text-white shadow">
        All Reviews
      </button>
      <button data-filter="5"
        class="rev-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">
        5 Stars
      </button>
      <button data-filter="critical"
        class="rev-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">
        Critical
      </button>
    </div>

    <div class="relative">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
      <input id="rev-search" type="text" placeholder="Search by doctor or patient..."
        class="pl-9 pr-4 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm font-medium text-slate-700 shadow-sm
               focus:outline-none focus:ring-2 focus:ring-brand-blue/30 w-72 transition-all" />
    </div>

  </div>

  <%-- ===== Reviews Feed (rendered by JS) ===== --%>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6" id="reviews-feed">
    <%-- Populated dynamically --%>
  </div>

</div>

<%-- ===== Reviews Page Script ===== --%>
<script>
window.__pageInit = function () {

  /* ------------------------------------------------------------------
   * Sample reviews data — replace with server-side injection, e.g.:
   *   var reviewsData = ${reviewsDataJson};
   * ------------------------------------------------------------------ */
  var reviewsData = [
    {
      id: 1,
      patient: 'Rohan Mehta',
      doctor:  'Dr. Aryan Kapoor',
      rating:  5,
      date:    'May 14, 2026',
      comment: 'Dr. Kapoor was very patient and explained the procedure clearly. The front desk staff was also very helpful with the insurance paperwork.',
      tags:    ['Clear Explanation', 'Friendly Staff']
    },
    {
      id: 2,
      patient: 'Anjali Verma',
      doctor:  'Dr. Sneha Reddy',
      rating:  4,
      date:    'May 12, 2026',
      comment: 'Great experience with the doctor. Wait time was a bit longer than expected, but the consultation was worth it.',
      tags:    ['Expert Advice']
    },
    {
      id: 3,
      patient: 'Karan Patel',
      doctor:  'Dr. Aryan Kapoor',
      rating:  5,
      date:    'May 10, 2026',
      comment: 'Excellent facility and highly professional doctors. Highly recommend Upachaar.',
      tags:    ['Professional', 'Clean Clinic']
    },
    {
      id: 4,
      patient: 'Sneha Gupta',
      doctor:  'Dr. Vikram Seth',
      rating:  3,
      date:    'May 08, 2026',
      comment: 'Doctor was good, but I had trouble finding parking near the clinic.',
      tags:    ['Punctual']
    }
  ];

  var activeFilter = 'all';
  var searchTerm   = '';

  /* ---------- Helpers ---------- */
  function escapeHtml(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(String(str)));
    return div.innerHTML;
  }

  function buildStars(rating) {
    var html = '';
    for (var i = 0; i < 5; i++) {
      var fill = i < rating ? 1 : 0;
      html += '<span class="material-symbols-outlined text-[18px]"' +
              ' style="font-variation-settings:\'FILL\' ' + fill + '">star</span>';
    }
    return html;
  }

  function buildTags(tags) {
    return tags.map(function (t) {
      return '<span class="px-2.5 py-1 bg-slate-50 text-slate-500 rounded-lg text-[10px] font-bold border border-slate-100">' +
             escapeHtml(t) + '</span>';
    }).join('');
  }

  /* ---------- Render reviews ---------- */
  function renderReviews() {
    var feed = document.getElementById('reviews-feed');

    var filtered = reviewsData.filter(function (r) {
      var q           = searchTerm.toLowerCase();
      var matchSearch = r.patient.toLowerCase().indexOf(q) !== -1 ||
                        r.doctor.toLowerCase().indexOf(q)  !== -1;
      var matchFilter = activeFilter === 'all' ||
                        (activeFilter === '5'       && r.rating === 5) ||
                        (activeFilter === 'critical' && r.rating <= 3);
      return matchSearch && matchFilter;
    });

    document.getElementById('total-rev-count').textContent = reviewsData.length;

    if (filtered.length === 0) {
      feed.innerHTML = '<div class="col-span-full py-20 text-center text-slate-400 font-medium">' +
                       'No reviews found matching your criteria.</div>';
      return;
    }

    feed.innerHTML = filtered.map(function (r) {
      var color    = window.avatarColor(r.patient);
      var initials = window.initials(r.patient);

      return '<div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm hover:shadow-md transition-all">' +

               '<div class="flex justify-between items-start mb-4">' +
                 '<div class="flex items-center gap-3">' +
                   '<div class="size-10 rounded-full flex items-center justify-center text-xs font-bold"' +
                        ' style="background:' + color + '22;color:' + color + '">' +
                     escapeHtml(initials) +
                   '</div>' +
                   '<div>' +
                     '<p class="font-bold text-slate-800 text-sm">'  + escapeHtml(r.patient) + '</p>' +
                     '<p class="text-[11px] text-slate-400 font-medium">' + escapeHtml(r.date) + '</p>' +
                   '</div>' +
                 '</div>' +
                 '<div class="flex text-amber-400">' + buildStars(r.rating) + '</div>' +
               '</div>' +

               '<div class="mb-4">' +
                 '<p class="text-xs font-bold text-brand-blue uppercase tracking-tighter mb-1">' +
                   'Review for ' + escapeHtml(r.doctor) +
                 '</p>' +
                 '<p class="text-sm text-slate-600 leading-relaxed italic">&ldquo;' +
                   escapeHtml(r.comment) +
                 '&rdquo;</p>' +
               '</div>' +

               '<div class="flex flex-wrap gap-2">' + buildTags(r.tags) + '</div>' +

               '<div class="mt-6 pt-4 border-t border-slate-50 flex justify-end gap-3">' +
                 '<button class="text-[11px] font-bold text-slate-400 hover:text-brand-blue transition-colors uppercase tracking-widest">Share</button>' +
                 '<button class="text-[11px] font-bold text-slate-400 hover:text-brand-blue transition-colors uppercase tracking-widest">Acknowledge</button>' +
               '</div>' +

             '</div>';
    }).join('');
  }

  /* ---------- Filter buttons ---------- */
  document.querySelectorAll('.rev-filter-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      activeFilter = btn.dataset.filter;

      document.querySelectorAll('.rev-filter-btn').forEach(function (b) {
        b.className = 'rev-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800';
      });
      btn.className = 'rev-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-brand-blue text-white shadow';

      renderReviews();
    });
  });

  /* ---------- Search ---------- */
  document.getElementById('rev-search').addEventListener('input', function () {
    searchTerm = this.value;
    renderReviews();
  });

  /* ---------- Initial render ---------- */
  renderReviews();
};
</script>
