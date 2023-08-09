package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.vungle.ads.InitializationListener
import com.vungle.ads.VungleAds
import com.vungle.ads.VungleError
import com.vungle.samples.samplekotlin.databinding.FragmentPlacementBinding
import com.vungle.samples.samplekotlin.ui.PlacementAdapter

class PlacementFragment : Fragment(R.layout.fragment_placement) {

    //    private var layoutManager: RecyclerView.LayoutManager? = null
//    private var adapter: RecyclerView.Adapter<PlacementAdapter.ViewHolder>? = null
    companion object {
        const val TAG = "VungleAds"
        const val APP_ID: String = "643d1db1143d3bfd6bcf6510"
        const val INTERSTITIAL_PLACEMENT: String = "INTERSTITIAL_NON_BIDDING-5048200"
        const val REWARD_PLACEMENT = "REWARDED_VIDEO_NON_BIDDING-0010836"
        const val MREC_PLACEMENT = "MREC_NON_BIDDING-4205088"
        const val BANNER_PLACEMENT = "BANNER_NON_BIDDING-4570799"
        const val NATIVE_PLACEMENT = "NATIVE_NON_BIDDING-7989926"
    }

    private var _binding: FragmentPlacementBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentPlacementBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        VungleAds.init(requireContext(), APP_ID, object : InitializationListener {
            override fun onSuccess() {
                Log.d(TAG, "onSuccess()")
            }

            override fun onError(vungleError: VungleError) {
                Log.d(TAG, "onError(): ${vungleError.localizedMessage}")
            }
        })

        val itemList: MutableList<PlacementAdapter.Item> = mutableListOf()
        itemList.add(
            PlacementAdapter.Item(
                "Interstitial",
                INTERSTITIAL_PLACEMENT
            )
        )
        itemList.add(
            PlacementAdapter.Item(
                "Rewarded Video", REWARD_PLACEMENT
            )
        )
        itemList.add(
            PlacementAdapter.Item(
                "MREC", MREC_PLACEMENT
            )
        )
        itemList.add(
            PlacementAdapter.Item(
                "Banner", BANNER_PLACEMENT
            )
        )
        itemList.add(
            PlacementAdapter.Item(
                "Native", NATIVE_PLACEMENT
            )
        )

        binding.tblPlacementList.apply {
            layoutManager = LinearLayoutManager(activity)
            adapter = PlacementAdapter(itemList) { adItem ->
                val destination = with(adItem.placementType) {
                    when {
                        contains("Rewarded") -> R.id.action_nav_placement_list_to_nav_rewarded
                        contains("Banner") -> R.id.action_nav_placement_list_to_nav_banner
                        contains("MREC") -> R.id.action_nav_placement_list_to_nav_mrec
                        contains("Native") -> R.id.action_nav_placement_list_to_nav_nativead
                        else -> R.id.action_nav_placement_list_to_nav_interstitial
                    }
                }
                val bundle = Bundle()
                bundle.putString("placement_id", adItem.placementId)
                findNavController().navigate(destination, bundle)
            }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}