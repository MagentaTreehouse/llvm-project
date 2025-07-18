// -*- C++ -*-
//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___FUNCTIONAL_REFERENCE_WRAPPER_H
#define _LIBCPP___FUNCTIONAL_REFERENCE_WRAPPER_H

#include <__compare/synth_three_way.h>
#include <__concepts/convertible_to.h>
#include <__config>
#include <__functional/weak_result_type.h>
#include <__memory/addressof.h>
#include <__type_traits/common_reference.h>
#include <__type_traits/desugars_to.h>
#include <__type_traits/enable_if.h>
#include <__type_traits/invoke.h>
#include <__type_traits/is_const.h>
#include <__type_traits/is_core_convertible.h>
#include <__type_traits/is_same.h>
#include <__type_traits/is_specialization.h>
#include <__type_traits/remove_cvref.h>
#include <__type_traits/void_t.h>
#include <__utility/declval.h>
#include <__utility/forward.h>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

_LIBCPP_BEGIN_NAMESPACE_STD

template <class _Tp>
class reference_wrapper : public __weak_result_type<_Tp> {
public:
  // types
  typedef _Tp type;

private:
  type* __f_;

  static void __fun(_Tp&) _NOEXCEPT;
  static void __fun(_Tp&&) = delete; // NOLINT(modernize-use-equals-delete) ; This is llvm.org/PR54276

public:
  template <class _Up,
            class = __void_t<decltype(__fun(std::declval<_Up>()))>,
            __enable_if_t<!is_same<__remove_cvref_t<_Up>, reference_wrapper>::value, int> = 0>
  _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 reference_wrapper(_Up&& __u)
      _NOEXCEPT_(noexcept(__fun(std::declval<_Up>()))) {
    type& __f = static_cast<_Up&&>(__u);
    __f_      = std::addressof(__f);
  }

  // access
  _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 operator type&() const _NOEXCEPT { return *__f_; }
  _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 type& get() const _NOEXCEPT { return *__f_; }

  // invoke
  template <class... _ArgTypes>
  _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 __invoke_result_t<type&, _ArgTypes...>
  operator()(_ArgTypes&&... __args) const
#if _LIBCPP_STD_VER >= 17
      // Since is_nothrow_invocable requires C++17 LWG3764 is not backported
      // to earlier versions.
      noexcept(is_nothrow_invocable_v<_Tp&, _ArgTypes...>)
#endif
  {
    return std::__invoke(get(), std::forward<_ArgTypes>(__args)...);
  }

#if _LIBCPP_STD_VER >= 26

  // [refwrap.comparisons], comparisons

  _LIBCPP_HIDE_FROM_ABI friend constexpr bool operator==(reference_wrapper __x, reference_wrapper __y)
    requires requires {
      { __x.get() == __y.get() } -> __core_convertible_to<bool>;
    }
  {
    return __x.get() == __y.get();
  }

  _LIBCPP_HIDE_FROM_ABI friend constexpr bool operator==(reference_wrapper __x, const _Tp& __y)
    requires requires {
      { __x.get() == __y } -> __core_convertible_to<bool>;
    }
  {
    return __x.get() == __y;
  }

  _LIBCPP_HIDE_FROM_ABI friend constexpr bool operator==(reference_wrapper __x, reference_wrapper<const _Tp> __y)
    requires(!is_const_v<_Tp>) && requires {
      { __x.get() == __y.get() } -> __core_convertible_to<bool>;
    }
  {
    return __x.get() == __y.get();
  }

  _LIBCPP_HIDE_FROM_ABI friend constexpr auto operator<=>(reference_wrapper __x, reference_wrapper __y)
    requires requires { std::__synth_three_way(__x.get(), __y.get()); }
  {
    return std::__synth_three_way(__x.get(), __y.get());
  }

  _LIBCPP_HIDE_FROM_ABI friend constexpr auto operator<=>(reference_wrapper __x, const _Tp& __y)
    requires requires { std::__synth_three_way(__x.get(), __y); }
  {
    return std::__synth_three_way(__x.get(), __y);
  }

  _LIBCPP_HIDE_FROM_ABI friend constexpr auto operator<=>(reference_wrapper __x, reference_wrapper<const _Tp> __y)
    requires(!is_const_v<_Tp>) && requires { std::__synth_three_way(__x.get(), __y.get()); }
  {
    return std::__synth_three_way(__x.get(), __y.get());
  }

#endif // _LIBCPP_STD_VER >= 26
};

#if _LIBCPP_STD_VER >= 17
template <class _Tp>
reference_wrapper(_Tp&) -> reference_wrapper<_Tp>;
#endif

template <class _Tp>
inline _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 reference_wrapper<_Tp> ref(_Tp& __t) _NOEXCEPT {
  return reference_wrapper<_Tp>(__t);
}

template <class _Tp>
inline _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 reference_wrapper<_Tp>
ref(reference_wrapper<_Tp> __t) _NOEXCEPT {
  return __t;
}

template <class _Tp>
inline _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 reference_wrapper<const _Tp> cref(const _Tp& __t) _NOEXCEPT {
  return reference_wrapper<const _Tp>(__t);
}

template <class _Tp>
inline _LIBCPP_HIDE_FROM_ABI _LIBCPP_CONSTEXPR_SINCE_CXX20 reference_wrapper<const _Tp>
cref(reference_wrapper<_Tp> __t) _NOEXCEPT {
  return __t;
}

template <class _Tp>
void ref(const _Tp&&) = delete;
template <class _Tp>
void cref(const _Tp&&) = delete;

// Let desugars-to pass through std::reference_wrapper
template <class _CanonicalTag, class _Operation, class... _Args>
inline const bool __desugars_to_v<_CanonicalTag, reference_wrapper<_Operation>, _Args...> =
    __desugars_to_v<_CanonicalTag, _Operation, _Args...>;

#if _LIBCPP_STD_VER >= 20

template <class _Tp>
inline constexpr bool __is_ref_wrapper = __is_specialization_v<_Tp, reference_wrapper>;

template <class _Rp, class _Tp, class _RpQual, class _TpQual>
concept __ref_wrap_common_reference_exists_with = __is_ref_wrapper<_Rp> && requires {
  typename common_reference_t<typename _Rp::type&, _TpQual>;
} && convertible_to<_RpQual, common_reference_t<typename _Rp::type&, _TpQual>>;

template <class _Rp, class _Tp, template <class> class _RpQual, template <class> class _TpQual>
  requires(__ref_wrap_common_reference_exists_with<_Rp, _Tp, _RpQual<_Rp>, _TpQual<_Tp>> &&
           !__ref_wrap_common_reference_exists_with<_Tp, _Rp, _TpQual<_Tp>, _RpQual<_Rp>>)
struct basic_common_reference<_Rp, _Tp, _RpQual, _TpQual> {
  using type _LIBCPP_NODEBUG = common_reference_t<typename _Rp::type&, _TpQual<_Tp>>;
};

template <class _Tp, class _Rp, template <class> class _TpQual, template <class> class _RpQual>
  requires(__ref_wrap_common_reference_exists_with<_Rp, _Tp, _RpQual<_Rp>, _TpQual<_Tp>> &&
           !__ref_wrap_common_reference_exists_with<_Tp, _Rp, _TpQual<_Tp>, _RpQual<_Rp>>)
struct basic_common_reference<_Tp, _Rp, _TpQual, _RpQual> {
  using type _LIBCPP_NODEBUG = common_reference_t<typename _Rp::type&, _TpQual<_Tp>>;
};

#endif // _LIBCPP_STD_VER >= 20

_LIBCPP_END_NAMESPACE_STD

#endif // _LIBCPP___FUNCTIONAL_REFERENCE_WRAPPER_H
