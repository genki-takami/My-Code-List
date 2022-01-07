package jp.creative.primefunc.genki.takami.psynavi
/*
その他タブの処理
 */
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import jp.creative.primefunc.genki.takami.psynavi.databinding.SettingBinding

class Setting : Fragment() {

    // 変数
    private var _binding: SettingBinding? = null
    val binding get() = _binding!!

    // レイアウトの設定
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = SettingBinding.inflate(inflater, container, false)
        return binding.root
    }

    // レイアウトの作成
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        // コメントネームの編集
        binding.commentEditBtn.setOnClickListener {
            val intent = Intent(view.context,CommentNameEdit::class.java)
            startActivity(intent)
        }

        // 通知設定
        binding.notificationBtn.setOnClickListener {
            // 設定アプリの「Psyなび」へ遷移
            val intent = Intent(
                android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                Uri.parse("package:jp.creative.primefunc.genki.takami.psynavi")
            )
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
        }

        // 使用ガイド
        binding.userGuideBtn.setOnClickListener {
            val intent = Intent(view.context,UserGuide::class.java)
            startActivity(intent)
        }

        // 利用規約
        binding.userPolicy.setOnClickListener {
            val intent = Intent(view.context,UserPolicy::class.java)
            startActivity(intent)
        }

        // プライバシーポリシー
        binding.privacyPolicyBtn.setOnClickListener {
            val intent = Intent(view.context,PrivacyPolicy::class.java)
            startActivity(intent)
        }

        // お問い合わせ
        binding.contactMeBtn.setOnClickListener {
            val intent = Intent(view.context,ContactForm::class.java)
            startActivity(intent)
        }

        // 運営
        binding.managerInfoBtn.setOnClickListener {
            val intent = Intent(view.context,ManagerInfo::class.java)
            startActivity(intent)
        }

        super.onViewCreated(view, savedInstanceState)
    }
}