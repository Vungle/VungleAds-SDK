package com.vungle.samples.samplekotlin.utils.extensions

import android.content.Context
import android.content.res.TypedArray
import android.graphics.drawable.Drawable
import android.util.AttributeSet
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.ViewTreeObserver
import android.view.inputmethod.InputMethodManager
import android.widget.Button
import android.widget.TextView
import androidx.annotation.AttrRes
import androidx.annotation.ColorInt
import androidx.annotation.ColorRes
import androidx.annotation.DrawableRes
import androidx.annotation.StyleableRes
import androidx.core.content.ContextCompat
import androidx.core.graphics.ColorUtils
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.material.snackbar.BaseTransientBottomBar
import com.google.android.material.snackbar.Snackbar
import com.vungle.samples.samplekotlin.R
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

inline fun View.obtainAttrs(
    attrs: AttributeSet?,
    @StyleableRes style: IntArray,
    defaultStyleAttr: Int = 0,
    defStyleRes: Int = 0,
    predicate: TypedArray.() -> Unit
) {
    val a = context.theme.obtainStyledAttributes(attrs, style, defaultStyleAttr, defStyleRes)
    try {
        predicate(a)
    } finally {
        a.recycle()
    }
}

@ColorInt
fun View.getSupportColor(@ColorRes colorRes: Int): Int {
    return ContextCompat.getColor(context, colorRes)
}

@ColorInt
fun View.getSupportColor(@ColorRes colorRes: Int, alpha: Int): Int {
    return ColorUtils.setAlphaComponent(ContextCompat.getColor(context, colorRes), alpha)
}

fun View.getSupportDrawable(@DrawableRes drawableRes: Int): Drawable? {
    return ContextCompat.getDrawable(context, drawableRes)
}

@ColorInt
fun View.getAttrColor(@AttrRes attrRes: Int): Int {
    val typedValue = TypedValue()
    val theme = context.theme
    theme.resolveAttribute(attrRes, typedValue, true)
    return typedValue.data
}

fun measureDimension(desiredSize: Int, measureSpec: Int): Int {
    var result: Int
    val specMode = View.MeasureSpec.getMode(measureSpec)
    val specSize = View.MeasureSpec.getSize(measureSpec)
    if (specMode == View.MeasureSpec.EXACTLY) {
        result = specSize
    } else {
        result = desiredSize
        if (specMode == View.MeasureSpec.AT_MOST) {
            result = result.coerceAtMost(specSize)
        }
    }
    if (result < desiredSize) {
        Log.e("TargetStatsView", "The view is too small, the content might get cut")
    }
    return View.MeasureSpec.makeMeasureSpec(result, specMode)
}

fun View.doOnApplyWindowInsets(f: (View, WindowInsetsCompat, InitialPadding) -> Unit) {
    // Create a snapshot of the view's padding state
    val initialPadding = recordInitialPaddingForView(this)
    // Set an actual OnApplyWindowInsetsListener which proxies to the given
    // lambda, also passing in the original padding state
    ViewCompat.setOnApplyWindowInsetsListener(this) { v, insets ->
        f(v, insets, initialPadding)
        // Always return the insets, so that children can also use them
        insets
    }
    // request some insets
    requestApplyInsetsWhenAttached()
}

fun View.requestApplyInsetsWhenAttached() {
    if (isAttachedToWindow) {
        // We're already attached, just request as normal
        requestApplyInsets()
    } else {
        // We're not attached to the hierarchy, add a listener to
        // request when we are
        addOnAttachStateChangeListener(object : View.OnAttachStateChangeListener {
            override fun onViewAttachedToWindow(v: View) {
                v.removeOnAttachStateChangeListener(this)
                v.requestApplyInsets()
            }

            override fun onViewDetachedFromWindow(v: View) = Unit
        })
    }
}

data class InitialPadding(val left: Int, val top: Int, val right: Int, val bottom: Int)

private fun recordInitialPaddingForView(view: View) = InitialPadding(
    view.paddingLeft, view.paddingTop, view.paddingRight, view.paddingBottom
)

fun View.show(isShow: Boolean = true) {
    visibility = if (isShow) View.VISIBLE else View.INVISIBLE
}

fun View.show() {
    visibility = View.VISIBLE
}

fun View.hide() {
    visibility = View.INVISIBLE
}

fun View.gone(isGone: Boolean = true) {
    visibility = if (isGone) View.GONE else View.VISIBLE
}

fun View.gone() {
    visibility = View.GONE
}

fun viewGones(vararg views: View) {
    for (view in views) {
        view.gone()
    }
}

fun viewVisibles(vararg views: View) {
    for (view in views) {
        view.show()
    }
}

fun View.showKeyboard() {
    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    if (this.requestFocus()) {
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, InputMethodManager.HIDE_IMPLICIT_ONLY)
    }
}

fun View.hideKeyboard() {
    val imm = context.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
    imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0)
}

/**
 * Transforms static java function Snackbar.make() to an extension function on View.
 */
fun View.showSnackbar(snackbarText: String, timeLength: Int) {
    Snackbar.make(this, snackbarText, timeLength).show()
}

/**
 * Transforms static java function Snackbar.make() to an extension function on View.
 * Using EspressoIdlingResource to wait animation end when ui test running
 */
inline fun View.showSnackbar(snackbarText: String, timeLength: Int, moreSetup: (Snackbar) -> Unit) {
    val snackbar = Snackbar.make(this, snackbarText, timeLength)
    moreSetup(snackbar)
//    EspressoIdlingResource.increment()
    snackbar.addCallback(object : BaseTransientBottomBar.BaseCallback<Snackbar?>() {
        override fun onShown(transientBottomBar: Snackbar?) {
//            EspressoIdlingResource.decrement()
            snackbar.removeCallback(this)
        }
    })
    snackbar.show()
}

/**
 * Set debounce onclick listener
 */
inline fun View.clickDebounce(scope: CoroutineScope, timePrevent: Long = 1000, crossinline block: (View) -> Unit) {
    setOnClickListener(object : View.OnClickListener { // ktlint-disable
        var job: Job? = null
        override fun onClick(view: View) {
            job?.cancel()
            job = scope.launch {
                delay(timePrevent)
                withContext(Dispatchers.Main) { block(view) }
            }
        }
    })
}

/**
 * Sets an on click listener for a view, but ensures the action cannot be triggered more often than [timePrevent] milliseconds.
 */
inline fun View.clickPreventDouble(
    timePrevent: Long = 1000L,
    crossinline action: (view: View) -> Unit
) {
    setOnClickListener(object : View.OnClickListener { //ktlint-disable
        var lastTime = 0L
        override fun onClick(v: View) {
            val now = System.currentTimeMillis()
            if (now - lastTime > timePrevent) {
                action(v)
                lastTime = now
            }
        }
    })
}

inline fun <T> viewSameAction(vararg views: T, block: (T) -> Unit) {
    for (view in views) {
        block(view)
    }
}

inline fun <T : View> T.afterMeasured(crossinline f: T.() -> Unit) {
    viewTreeObserver.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
        override fun onGlobalLayout() {
            if (measuredWidth > 0 && measuredHeight > 0) {
                viewTreeObserver.removeOnGlobalLayoutListener(this)
                f()
            }
        }
    })
}

val ViewGroup.inflater: LayoutInflater get() = LayoutInflater.from(context)

fun View.setMargin(left: Int = 0, top: Int = 0, right: Int = 0, bottom: Int = 0) {
    val menuLayoutParams = this.layoutParams as ViewGroup.MarginLayoutParams
    menuLayoutParams.setMargins(left, top, right, bottom)
    this.layoutParams = menuLayoutParams
}

fun TextView.blackText() {
    setTextColor(ContextCompat.getColor(context, R.color.black))
}

fun TextView.lightGrayText() {
    setTextColor(ContextCompat.getColor(context, R.color.lightGray))
}

fun Button.toggleBackground(selectedId: Int) {
    backgroundTintList =
        ContextCompat.getColorStateList(
            context,
            if (selectedId == id) R.color.button_blue else
                R.color.button_gray
        )
}

fun View.isSelectedBg(condition: Boolean) {
    backgroundTintList =
        ContextCompat.getColorStateList(
            context,
            if(condition) R.color.button_blue else
                R.color.button_gray
        )
}

