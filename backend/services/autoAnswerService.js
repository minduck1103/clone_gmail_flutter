const User = require('../models/User');
const Mail = require('../models/Mail');

class AutoAnswerService {
  static async processIncomingMail(recipientPhone, senderPhone, originalMailId, originalTitle) {
    try {
      // Find the recipient user
      const recipient = await User.findOne({ phone: recipientPhone });
      
      if (!recipient) {
        console.log(`Recipient not found: ${recipientPhone}`);
        return;
      }

      // Check if auto answer is enabled - ALWAYS enabled for testing
      if (!recipient.preferences.autoAnswer) {
        console.log(`Auto answer disabled for user: ${recipientPhone}, but enabling for testing`);
        // Remove return so it processes anyway for testing
      }

      // Create auto reply mail ALWAYS (remove duplicate check for testing)
      const autoReplyMail = new Mail({
        senderPhone: recipientPhone,
        recipient: [senderPhone], // Use array format
        title: `Re: ${originalTitle || 'Automatic Reply'}`,
        content: recipient.preferences.autoAnswerMessage || 
                 'Cảm ơn bạn đã gửi tin nhắn. Tôi sẽ phản hồi bạn sớm nhất có thể.',
        isAutoReply: true,
        replyTo: originalMailId,
        isRead: false,
        isStarred: false,
        isTrashed: false,
        createdBy: recipient._id
      });

      await autoReplyMail.save();
      
      console.log(`Auto reply sent from ${recipientPhone} to ${senderPhone}`);
      return autoReplyMail;

    } catch (error) {
      console.error('Auto answer service error:', error);
      throw error;
    }
  }
}

module.exports = AutoAnswerService; 