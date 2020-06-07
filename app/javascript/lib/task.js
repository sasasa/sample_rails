export function deleteTr() {
  window.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.delete').forEach((a) => {
      a.addEventListener('ajax:success', () => {
        var td = a.parentNode;
        var tr = td.parentNode;
        // tr.style.display = 'none';
        $(tr).css({background: 'red'});
        $(tr).fadeOut("slow");
        // alert('削除されました。')
      });
    });
  });
}