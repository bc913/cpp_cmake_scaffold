#ifndef SORT_H_
#define SORT_H_

#include <iterator>
#include <algorithm>
#include <functional>

namespace bc
{
    namespace impl
    {
        template<typename RanIter, typename Compare>
        void sift_down(RanIter first, RanIter last, Compare comp, RanIter start)
        {
            typedef typename std::iterator_traits<RanIter>::difference_type diff_t;

            diff_t len = last - first;
            diff_t index = start - first;
            if(len < 2 || (len - 2) / 2 < index) return;

            while(true)
            {
                diff_t runner = index, l = 2*index + 1, r = l + 1;
                if(l < len && comp(*(first+runner), *(first+l))) runner = l;
                if(r < len && comp(*(first+runner), *(first+r))) runner = r;

                if(runner == index) break;
                std::swap(*(first+runner), *(first+index));
                index = runner;
            }
        }

        template<typename RanIter, typename Compare>
        void sift_up(RanIter first, RanIter last, Compare comp)
        {
            typedef typename std::iterator_traits<RanIter>::difference_type diff_t;
            typedef typename std::iterator_traits<RanIter>::value_type      value_t;

            diff_t len = last - first;
            if(len <= 1) return;

            diff_t hole_index = len - 1;
            value_t hole_value = *(last - 1);
            diff_t parent_index = (hole_index - 1) / 2;

            while(0 < hole_index && comp(*(first+parent_index), hole_value))
            {
                *(first+hole_index) = std::move(*(first+parent_index));
                hole_index = parent_index;
                parent_index = (hole_index - 1) / 2;
            }

            *(first + hole_index) = std::move(hole_value);
        }

        template<typename RanIter, typename Compare>
        void make_heap(RanIter first, RanIter last, Compare comp)
        {
            typedef typename std::iterator_traits<RanIter>::difference_type diff_t;
            diff_t len = last - first;
            if(len > 1)
            {
                for(diff_t index = (len - 2) / 2; 0 <= index; --index)
                    impl::sift_down(first, last, comp, first + index);
            }
        }

        template<typename RanIter, typename Compare>
        void pop_heap(RanIter first, RanIter last, Compare comp)
        {
            typedef typename std::iterator_traits<RanIer>::difference_type diff_t;
            diff_t len = last - first;
            if(len > 1)
            {
                std::swap(*first, *--last);
                impl::sift_down(first, last, comp, first);
            }
        }

        template<typename RanIter, typename Compare>
        void push_heap(RanIter first, RanIter last, Compare comp)
        {
            impl::sift_up(first, last, comp);
        }

        template<typename RanIter, typename Compare>
        void heap_sort(RanIter first, RanIter last, Compare comp)
        {
            impl::make_heap(first, last, comp);
            while(first != --last)
            {
                std::swap(*first, *last);
                impl::sift_down(first, last, comp, first);
            }            
        }
    }

    template<typename RanIter>
    void heap_sort(RanIter first, RanIter last)
    {
        impl::heap_sort(first, last, std::less<typename std::iterator_traits<RanIter>::value_type>());
    }

    template<typename RanIter, typename Compare>
    void heap_sort(RanIter first, RanIter last, Compare comp)
    {
        impl::heap_sort(first, last, comp);
    }
}

#endif